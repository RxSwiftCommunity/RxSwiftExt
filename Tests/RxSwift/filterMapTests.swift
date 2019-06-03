//
//  FilterMapTests.swift
//  RxSwiftExt
//
//  Created by Jeremie Girault on 31/05/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

final class FilterMapTests: XCTestCase {
    private var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        scheduler = nil
        super.tearDown()
    }

    func testIgnoreEvenAndEvenizeOdds() {
        let observer = scheduler.createObserver(Int.self)

        let values = 1..<10
        _ = Observable.from(values)
            .filterMap { $0 % 2 == 0 ? .ignore : .map(2*$0) }
            .subscribe(observer)

        scheduler.start()

        var correct = values
            .filter { $0 % 2 != 0 }
            .map { Recorded.next(0, 2 * $0) }

        correct.append(.completed(0))

        XCTAssertEqual(observer.events, correct)
    }

    func testErrorsWithSource() {
        let observer = scheduler.createObserver(Int.self)

        let subject = PublishSubject<Int>()
        _ = subject
            .filterMap { $0 % 2 == 0 ? .ignore : .map(2*$0) }
            .subscribe(observer)

        subject.on(.next(1))
        subject.on(.next(2))
        subject.on(.next(3))
        subject.on(.error(testError))

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 2),
            .next(0, 6),
            .error(0, testError)
        ])

        print(observer.events)

        XCTAssertEqual(observer.events, correct)
    }

    func testThrownError() {
        // Given
        let expectedErrored = 203
        let expectedEvents = Recorded.events([
            .next(201, 2),
            .error(expectedErrored, testError)
        ])
        let source = scheduler.createHotObservable([
            .next(201, 1),
            .next(202, 2),
            .next(expectedErrored, 3), // should not fire due to error on 3
            .next(204, 4),
            .completed(205)
        ])
        // When
        let result = scheduler.start {
            source.filterMap { element -> FilterMap<Int> in
                guard !element.isMultiple(of: 2) else {
                    return .ignore
                }
                guard element != 3 else {
                    throw testError
                }
                return .map(2 * element)
            }
        }
        // Then
        XCTAssertEqual(source.subscriptions, [Subscription(TestScheduler.Defaults.subscribed, expectedErrored)])
        XCTAssertEqual(result.events, expectedEvents)
    }
}
