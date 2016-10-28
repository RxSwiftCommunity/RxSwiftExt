//
//  cascadeTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 17/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class CascadeTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)
    
    let scheduler = TestScheduler(initialClock: 0)
    
    func testCascadeEmpty() {
        
        let emptySequence = Observable.from([Int]())

        let obs = scheduler.createObserver(Int.self)
		_ = Observable.cascade([emptySequence])
            .subscribe(obs)
        
        scheduler.start()
        
        XCTAssertEqual(
            obs.events.count-1 /*complete event*/,
            0
        )
    }
    
    func testCascadeOne() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            completed(600)
        ])

        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs])
        }

        XCTAssertEqual(res.events, [
            next(230, 3),
            completed(600)
        ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 600)
            ])
    }
    
    func testCascadeTwo() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600),
            next(610, 12),
            error(620, testError),
            completed(630)
            ])
        
        let ys = scheduler.createHotObservable([
            next(350, 26),
            next(390, 27),
            next(450, 28),
            next(470, 29),
            next(560, 30),
            completed(600),
            next(610, 31),
            error(620, testError),
            completed(630)
            ])

        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs, ys])
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(350, 26),
            next(390, 27),
            next(450, 28),
            next(470, 29),
            next(560, 30),
            completed(600)
            ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 350)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 600)
            ])
    }
    
    func testCascadeSkipMiddleSequence() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600),
            next(610, 12),
            error(620, testError),
            completed(630)
            ])
        
        let ys = scheduler.createHotObservable([
            next(350, 26),
            next(390, 27),
            next(450, 28),
            next(470, 29),
            next(560, 30),
            completed(600),
            next(610, 31),
            error(620, testError),
            completed(630)
            ])

        let zs = scheduler.createHotObservable([
            next(345, 126),
            next(400, 127),
            next(450, 128),
            next(451, 129),
            next(500, 130),
            completed(600),
            next(610, 31),
            error(620, testError),
            completed(630)
            ])

        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs,ys,zs])
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(345, 126),
            next(400, 127),
            next(450, 128),
            next(451, 129),
            next(500, 130),
            completed(600)
            ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 345)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 345)
            ])
        XCTAssertEqual(zs.subscriptions, [
            Subscription(200, 600)
            ])
    }
    
    func testCascadeImmediateError() {
        let xs = scheduler.createHotObservable([
            next(100, 1),
            error(210, testError),
            completed(630)
            ])
        
        let ys = scheduler.createHotObservable([
            next(350, 26),
            next(390, 27),
            next(450, 28),
            next(470, 29),
            next(560, 30),
            completed(600),
            next(610, 31),
            error(620, testError),
            completed(630)
            ])

        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs,ys])
        }
        
        XCTAssertEqual(res.events, [
            error(210, testError)
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 210)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 210)
            ])
    }
    
    func testCascadeErrorOnSecond() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600),
            next(610, 12),
            error(620, testError),
            completed(630)
            ])
        
        let ys = scheduler.createHotObservable([
            next(350, 26),
            next(390, 27),
            next(450, 28),
            error(480, testError),
            completed(630)
            ])
        
        let zs = scheduler.createHotObservable([
            next(500, 130),
            error(520, testError)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs,ys,zs])
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(350, 26),
            next(390, 27),
            next(450, 28),
            error(480, testError),
            ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 350)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 480)
            ])
        XCTAssertEqual(zs.subscriptions, [
            Subscription(200, 480)
            ])
    }
    
    func testOutOfOrderCompletion() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600),
            next(610, 12),
            error(620, testError),
            completed(630)
            ])
        
        let ys = scheduler.createHotObservable([
            next(350, 26),
            next(390, 27),
            completed(500)
            ])
        
        let zs = scheduler.createHotObservable([
            completed(400, Int.self)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs,ys,zs])
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(350, 26),
            next(390, 27),
            completed(500)
            ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 350)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 500)
            ])
        XCTAssertEqual(zs.subscriptions, [
            Subscription(200, 400)
            ])
    }
    
    func testImmediateCompletion() {
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            completed(400),
            ])
        
        let ys = scheduler.createHotObservable([
            next(100, 21),
            completed(210, Int.self)
            ])
        
        let zs = scheduler.createHotObservable([
            completed(350, Int.self)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            Observable.cascade([xs,ys,zs])
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            completed(400)
            ])
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 400)
            ])
        XCTAssertEqual(ys.subscriptions, [
            Subscription(200, 210)
            ])
        XCTAssertEqual(zs.subscriptions, [
            Subscription(200, 350)
            ])
    }
}
