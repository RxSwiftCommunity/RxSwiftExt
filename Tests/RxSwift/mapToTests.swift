//
//  MapToTests.swift
//  RxSwiftExt
//
//  Created by Marin Todorov on 4/12/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class MapToTests: XCTestCase {

    private let numbers: [Int?] = [1, nil, Int?(3)]
    private var observer: TestableObserver<String>!

    override func setUp() {
        super.setUp()

        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(String.self)

		_ = Observable.from(numbers)
            .mapTo("candy")
            .subscribe(observer)

        scheduler.start()
    }

    func testReplaceWithResultCount() {
        XCTAssertEqual(
            observer.events.count - 1, // completed event
            numbers.count
        )
    }

    func testReplaceWithResultValues() {
        // test elements values and type
        let correctValues = Recorded.events([
            .next(0, "candy"),
            .next(0, "candy"),
            .next(0, "candy"),
            .completed(0)
        ])
        XCTAssertEqual(observer.events, correctValues)
    }
}

// MARK: - Single
extension MapToTests {
    func testSingleReplaceSuccess() {
        // Given
        let expectedValue = "candy"
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Single.just(1).mapTo(expectedValue).asObservable()
        }
        // Then
        XCTAssertEqual(result.events, [
            .next(TestScheduler.Defaults.subscribed, expectedValue),
            .completed(TestScheduler.Defaults.subscribed)
        ])
    }

    func testSingleNoReplaceFailure() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Single<Int>.error(testError).mapTo("candy").asObservable()
        }
        // Then
        XCTAssertEqual(result.events, [.error(TestScheduler.Defaults.subscribed, testError)])
    }
}

// MARK: - Maybe
extension MapToTests {
    func testMaybeReplaceSuccess() {
        // Given
        let expectedValue = "candy"
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Maybe.just(1).mapTo(expectedValue).asObservable()
        }
        // Then
        XCTAssertEqual(result.events, [
            .next(TestScheduler.Defaults.subscribed, expectedValue),
            .completed(TestScheduler.Defaults.subscribed)
        ])
    }

    func testMaybeNoReplaceFailure() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Maybe<Int>.error(testError).mapTo("candy").asObservable()
        }
        // Then
        XCTAssertEqual(result.events, [.error(TestScheduler.Defaults.subscribed, testError)])
    }

    func testMaybeNoReplaceEmpty() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Maybe<Int>.empty().mapTo("candy").asObservable()
        }
        // Then
        XCTAssertEqual(result.events, [.completed(TestScheduler.Defaults.subscribed)])
    }
}
