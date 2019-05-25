//
//  SkipLastTests.swift
//  RxSwiftExt
//
//  Created by Anton Nazarov on 25/05/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import XCTest
import RxSwiftExt

class SkipLastTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var stream: TestableObservable<Int>!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        scheduler = nil
        super.tearDown()
    }

    func testSkipLastCompleteAfter() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .completed(690)
        ])
        // When
        let res = scheduler.start {
            xs.skipLast(20)
        }
        // Then
        XCTAssertEqual(res.events, [.completed(690)])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastCompleteBefore() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .completed(690)
        ])
        // When
        let res = scheduler.start {
            xs.skipLast(10)
        }
        // Then
        XCTAssertEqual(res.events, [
            .next(460, 9),
            .next(510, 13),
            .next(560, 7),
            .next(570, 1),
            .next(580, -1),
            .next(590, 3),
            .next(630, 8),
            .completed(690)
        ])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastCompleteZero() {
        // Given
        let events = Recorded.events([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .completed(690)
        ])
        let xs = scheduler.createHotObservable(events)
        // When
        let res = scheduler.start {
            xs.skipLast(0)
        }
        // Then
        XCTAssertEqual(res.events, Array(events.dropFirst(2)))
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastErrorAfter() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .error(690, testError)
        ])
        // When
        let res = scheduler.start {
            xs.skipLast(20)
        }
        // Then
        XCTAssertEqual(res.events, [.error(690, testError)])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastErrorSame() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .error(690, testError)
        ])
        // When
        let res = scheduler.start {
            xs.skipLast(17)
        }
        // Then
        XCTAssertEqual(res.events, [.error(690, testError)])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastErrorBefore() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
            .error(690, testError)
        ])
        // When
        let res = scheduler.start {
            xs.skipLast(3)
        }
        // Then
        XCTAssertEqual(res.events, [
            .next(280, 9),
            .next(300, 13),
            .next(310, 7),
            .next(340, 1),
            .next(370, -1),
            .next(410, 3),
            .next(415, 8),
            .next(460, 11),
            .next(510, 15),
            .next(560, 16),
            .next(570, 72),
            .next(580, 76),
            .next(590, 32),
            .next(630, -100),
            .error(690, testError)
        ])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, 690)])
    }

    func testSkipLastDisposeBefore() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
        ])
        let expectedDisposed = 250
        // When
        let res = scheduler.start(disposed: expectedDisposed) {
            xs.skipLast(3)
        }
        // Then
        XCTAssertTrue(res.events.isEmpty)
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedDisposed)])
    }

    func testSkipLastDisposeAfter() {
        // Given
        let xs = scheduler.createHotObservable([
            .next(70, 6),
            .next(150, 4),
            .next(210, 9),
            .next(230, 13),
            .next(270, 7),
            .next(280, 1),
            .next(300, -1),
            .next(310, 3),
            .next(340, 8),
            .next(370, 11),
            .next(410, 15),
            .next(415, 16),
            .next(460, 72),
            .next(510, 76),
            .next(560, 32),
            .next(570, -100),
            .next(580, -3),
            .next(590, 5),
            .next(630, 10),
        ])
        let expectedDisposed = 400
        // When
        let res = scheduler.start(disposed: expectedDisposed) {
            xs.skipLast(3)
        }
        // Then
        XCTAssertEqual(res.events, [
            .next(280, 9),
            .next(300, 13),
            .next(310, 7),
            .next(340, 1),
            .next(370, -1),
        ])
        XCTAssertEqual(xs.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedDisposed)])
    }
}
