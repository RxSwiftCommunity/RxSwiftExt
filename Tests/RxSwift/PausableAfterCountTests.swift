//
//  PausableAfterCountTests.swift
//  RxSwiftExt
//
//  Created by Anton Nazarov on 04/09/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxSwiftExt
import RxTest

final class PausableAfterCountTests: XCTestCase {
    private var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        scheduler = nil
        super.tearDown()
    }

    func testNoSkipBeforeCount() {
        // Given
        let pauserEvents = Recorded.events(
            .next(TestScheduler.Defaults.subscribed, true)
        )
        let expectedCompleted = 500
        let events = Recorded.events(
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(expectedCompleted)
        )
        let observable = scheduler.createHotObservable(events)
        let pauser = scheduler.createHotObservable(pauserEvents)
        // When
        let sut = scheduler.start {
            observable.pausable(afterCount: events.count, withPauser: pauser)
        }
        // Then
        XCTAssertEqual(sut.events, events)
        XCTAssertEqual(observable.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedCompleted)])
    }

    func testSkipAfterCount() {
        // Given
        let pauserEvents = Recorded.events(
            .next(TestScheduler.Defaults.subscribed, true)
        )
        let expectedCompleted = 500
        let events = Recorded.events(
            .next(210, 2),
            .next(230, 3),
            .next(301, 4),
            .next(350, 5),
            .next(399, 6),
            .completed(expectedCompleted)
        )
        let count = 3
        let expectedEvents = Array(events.prefix(count)) + [.completed(expectedCompleted)]
        let observable = scheduler.createHotObservable(events)
        let pauser = scheduler.createHotObservable(pauserEvents)
        // When
        let sut = scheduler.start {
            observable.pausable(afterCount: count, withPauser: pauser)
        }
        // Then
        XCTAssertEqual(sut.events, expectedEvents)
        XCTAssertEqual(observable.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedCompleted)])
    }

    func testPausedError() {
        // Given
        let pauserEvents = Recorded.events(
            .next(TestScheduler.Defaults.subscribed, true)
        )
        let expectedError = 301
        let events = Recorded.events(
            .next(210, 2),
            .next(230, 3),
            .error(expectedError, testError),
            .next(350, 5),
            .next(399, 6),
            .completed(500)
        )
        let count = 3
        let expectedEvents = Array(events.prefix(count))
        let observable = scheduler.createHotObservable(events)
        let pauser = scheduler.createHotObservable(pauserEvents)
        // When
        let sut = scheduler.start {
            observable.pausable(afterCount: count, withPauser: pauser)
        }
        // Then
        XCTAssertEqual(sut.events, expectedEvents)
        XCTAssertEqual(observable.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedError)])
    }
}
