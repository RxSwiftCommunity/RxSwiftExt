//
//  ignoreErrorsTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 18/05/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

// credits:
// tests for ignoreErrors() are the tests for retry() retargeted to the ignoreErrors() operator
// tests for ignoreWhen() are the tests for retry(count) adapted to the ignoreWhen() operator

class IgnoreErrorsTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)

    func testIgnoreErrors_Basic() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            completed(250)
            ])

        let res = scheduler.start {
            xs.ignoreErrors()
        }

        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            completed(450)
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450)
            ])
    }

    func testIgnoreErrors_Infinite() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            ])

        let res = scheduler.start {
            xs.ignoreErrors()
        }

        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 1000)
            ])
    }

    func testIgnoreErrors_Observable_Error() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            error(250, testError),
            ])

        let res = scheduler.start(disposed: 1100) {
            xs.ignoreErrors()
        }

        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            next(550, 1),
            next(600, 2),
            next(650, 3),
            next(800, 1),
            next(850, 2),
            next(900, 3),
            next(1050, 1)
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450),
            Subscription(450, 700),
            Subscription(700, 950),
            Subscription(950, 1100)
            ])
    }

    func testIgnoreErrors_PredicateBasic() {
        let scheduler = TestScheduler(initialClock: 0)
        var counter = 0
        
        let xs = scheduler.createColdObservable([
            next(5, 1),
            next(10, 2),
            next(15, 3),
            error(20, testError)
            ])

        let res = scheduler.start {
            xs.ignoreErrors { error -> Bool in
                counter += 1
                return counter < 3
            }
        }

        XCTAssertEqual(res.events, [
            next(205, 1),
            next(210, 2),
            next(215, 3),
            next(225, 1),
            next(230, 2),
            next(235, 3),
            next(245, 1),
            next(250, 2),
            next(255, 3),
            error(260, testError)
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 220),
            Subscription(220, 240),
            Subscription(240, 260)
            ])
    }

    func testIgnoreErrors_PredicateInfinite() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createColdObservable([
            next(5, 1),
            next(10, 2),
            next(15, 3),
            error(20, testError)
            ])

        let res = scheduler.start(disposed: 231) {
            xs.ignoreErrors { error -> Bool in
                return true
            }
        }

        XCTAssertEqual(res.events, [
            next(205, 1),
            next(210, 2),
            next(215, 3),
            next(225, 1),
            next(230, 2),
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 220),
            Subscription(220, 231),
            ])
    }

    func testIgnoreErrors_PredicateCompleted() {
        let scheduler = TestScheduler(initialClock: 0)

        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            completed(250)
            ])

        let res = scheduler.start {
            xs.ignoreErrors { error -> Bool in
                return true
            }
        }

        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            completed(450)
            ])

        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450),
            ])
    }
}
