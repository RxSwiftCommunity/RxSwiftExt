//
//  pausableTests.swift
//  RxSwiftExtDemo
//
//  Created by Jesse Farless on 12/09/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class PausableTests: XCTestCase {
    
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)

    let scheduler = TestScheduler(initialClock: 0)

    func testPausedNoSkip() {

        let underlying = scheduler.createHotObservable([
            next(150, 1),
            next(210, 2),
            next(230, 3),
            next(301, 4),
            next(350, 5),
            next(399, 6),
            completed(500),
        ])

        let pauser = scheduler.createHotObservable([
            next(201, true),
            next(205, false),
            next(209, true),
        ])

        let res = scheduler.start(disposed: 1000) {
			underlying.pausable(pauser)
        }

        XCTAssertEqual(res.events, [
            next(210, 2),
            next(230, 3),
            next(301, 4),
            next(350, 5),
            next(399, 6),
            completed(500),
        ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500),
        ])

    }

    func testPausedSkips() {

        let underlying = scheduler.createHotObservable([
            next(150, 1),
            next(210, 2),
            next(230, 3),
            next(301, 4),
            next(350, 5),
            next(399, 6),
            completed(500),
        ])

        let pauser = scheduler.createHotObservable([
            next(220, true),
            next(300, false),
            next(400, true),
        ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausable(pauser)
        }

        XCTAssertEqual(res.events, [
            next(230, 3),
            completed(500),
        ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 500),
        ])

    }

    func testPausedError() {

        let underlying = scheduler.createHotObservable([
            next(150, 1),
            next(210, 2),
            error(230, testError),
            next(301, 4),
            next(350, 5),
            next(399, 6),
            completed(500),
        ])

        let pauser = scheduler.createHotObservable([
            next(201, true),
            next(300, false),
            next(400, true),
        ])

        let res = scheduler.start(disposed: 1000) {
            underlying.pausable(pauser)
        }

        XCTAssertEqual(res.events, [
            next(210, 2),
            error(230, testError),
        ])

        XCTAssertEqual(underlying.subscriptions, [
            Subscription(200, 230),
        ])

    }
}
