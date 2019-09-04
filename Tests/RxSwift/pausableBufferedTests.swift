//
//  PausableBufferedTests.swift
//  RxSwiftExt
//
//  Created by Tanguy Helesbeux on 24/05/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class PausableBufferedTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)
    let scheduler = TestScheduler(initialClock: 0)

    func testPausedNoSkip() {
        let underlying = scheduler.createHotObservable([
            .next(150, 1),
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        let pauser = scheduler.createHotObservable([
            .next(201, true),
            .next(205, false),
            .next(209, true)
            ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausableBuffered(pauser)
        }

        XCTAssertEqual(res.events, [
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500)
            ])
    }

    func testPausedSkips() {
        let underlying = scheduler.createHotObservable([
            .next(150, 1),
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        let pauser = scheduler.createHotObservable([
            .next(220, true),
            .next(300, false),
            .next(400, true)
            ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausableBuffered(pauser)
        }

        XCTAssertEqual(res.events, [
            .next(220, 2),
            .next(230, 3),
            .next(400, 6),
            .completed(500)
            ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500)
            ])
    }

    func testPausedLimit() {
        let underlying = scheduler.createHotObservable([
            .next(150, 1),
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        let pauser = scheduler.createHotObservable([
            .next(220, true),
            .next(300, false),
            .next(400, true)
            ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausableBuffered(pauser, limit: 2)
        }

        XCTAssertEqual(res.events, [
            .next(220, 2),
            .next(230, 3),
            .next(400, 5),
            .next(400, 6),
            .completed(500)
            ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500)
            ])
    }

    func testPausedNoLimit() {
        let underlying = scheduler.createHotObservable([
            .next(150, 1),
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        let pauser = scheduler.createHotObservable([
            .next(220, true),
            .next(300, false),
            .next(400, true)
            ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausableBuffered(pauser, limit: nil)
        }

        XCTAssertEqual(res.events, [
            .next(220, 2),
            .next(230, 3),
            .next(400, 4),
            .next(400, 5),
            .next(400, 6),
            .completed(500)
            ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500)
            ])
    }

    func testPausedError() {
        let underlying = scheduler.createHotObservable([
            .next(150, 1),
            .next(210, 2),
            .error(230, testError),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
            ])

        let pauser = scheduler.createHotObservable([
            .next(201, true),
            .next(300, false),
            .next(400, true),
            .completed(600)
            ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausableBuffered(pauser)
        }

        XCTAssertEqual(res.events, [
            .next(210, 2),
            .error(230, testError)
            ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 230)
            ])
    }

    func testPausedReentrantPauser() {
        let underlying = scheduler.createHotObservable([
            .next(110, 1),
            .next(210, 2),
            .next(310, 3),
            .next(410, 4),
            .completed(500),
        ])

        let pauser = scheduler.createHotObservable([
            .next(301, true),
        ])

        let res = scheduler.start(disposed: 1000) { () -> Observable<Int> in
            return Observable.create { observer in
                let pauserSubject = PublishSubject<Bool>()
                let allPausers = Observable.merge(
                    pauser.asObservable(),
                    pauserSubject.asObservable())

                let buffered = underlying
                    .pausableBuffered(allPausers, limit: nil)
                    .share()

                let pauserEcho = buffered
                    .take(2)
                    .map { _ in true }
                    .bind(to: pauserSubject)

                return Disposables.create(pauserEcho, buffered.subscribe(observer))
            }
        }

        XCTAssertEqual(res.events, [
            .next(301, 2),
            .next(310, 3),
            .next(410, 4),
            .completed(500),
        ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500),
            ])
    }

    func testPausedReentrantUnderlying() {
        let underlying = scheduler.createHotObservable([
            .next(210, 1),
            .next(210, 2),
            .next(210, 3),
            .next(310, 4),
            .completed(500),
        ])

        let pauser = scheduler.createHotObservable([
            .next(301, true),
        ])

        let res = scheduler.start(disposed: 1000) { () -> Observable<Int> in
            return Observable.create { observer in
                let underlyingSubject = PublishSubject<Int>()
                let allUnderlying = Observable.merge(
                    underlying.asObservable(),
                    underlyingSubject.asObservable())

                let buffered = allUnderlying
                    .pausableBuffered(pauser, limit: nil)
                    .share()

                let underlyingEcho = buffered
                    .take(2)
                    .bind(to: underlyingSubject)

                return Disposables.create(underlyingEcho, buffered.subscribe(observer))
            }
        }

        XCTAssertEqual(res.events, [
            .next(301, 1),
            .next(301, 2),
            .next(301, 3),
            .next(301, 1),
            .next(301, 2),
            .next(310, 4),
            .completed(500),
        ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500),
            ])
    }
}
