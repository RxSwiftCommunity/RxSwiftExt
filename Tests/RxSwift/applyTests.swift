//
//  applyTests.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 2/22/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class ApplyTests: XCTestCase {

    func transform(input: Observable<Int>) -> Observable<Int> {
        return input
            .filter { $0 > 0 }
            .map { $0 * $0 }
    }

    func testApply() {
        let values = [0, 42, -7, 100, 1000, 1]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .apply(transform)
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 42*42),
            .next(0, 100*100),
            .next(0, 1000*1000),
            .next(0, 1*1),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func transformToString(input: Observable<Int>) -> Observable<String> {
        return input
            .distinctUntilChanged()
            .map { String(describing: $0) }
    }

    func testApplyTransformingType() {
        let values = [0, 0, 42, 42, -7, 100, 1000, 1, 1]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)

        _ = Observable.from(values)
            .apply(transformToString)
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, "0"),
            .next(0, "42"),
            .next(0, "-7"),
            .next(0, "100"),
            .next(0, "1000"),
            .next(0, "1"),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }
}

// MARK: - Single
extension ApplyTests {
    private func transformToString(input: Single<Int>) -> Single<String> {
        return input.map(String.init)
    }

    private func transform(input: Single<Int>) -> Single<Int> {
        return input.map { $0 * $0 }
    }

    func testApplySingle() {
        // Given
        let value = 10
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Single.just(value).apply(self.transform).asObservable()
        }
        // Then
        let correct = Recorded.events([
            .next(TestScheduler.Defaults.subscribed, 10 * 10),
            .completed(TestScheduler.Defaults.subscribed)
        ])
        XCTAssertEqual(result.events, correct)
    }

    func testApplyTransformingTypeSingle() {
        // Given
        let value = -7
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Single.just(value).apply(self.transformToString).asObservable()
        }
        let correct = Recorded.events([
            .next(TestScheduler.Defaults.subscribed, "-7"),
            .completed(TestScheduler.Defaults.subscribed)
        ])
        XCTAssertEqual(result.events, correct)
    }
}

// MARK: - Maybe
extension ApplyTests {
    private func transform(input: Maybe<Int>) -> Maybe<Int> {
        return input.map { $0 * $0 }
    }

    func testApplyMaybe() {
        // Given
        let value = 10
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Maybe.just(value).apply(self.transform).asObservable()
        }
        // Then
        XCTAssertEqual(result.events, Recorded.events([
            .next(TestScheduler.Defaults.subscribed, value * value),
            .completed(TestScheduler.Defaults.subscribed)
        ]))
    }
}

// MARK: - Completable
extension ApplyTests {
    private func transform(input: Completable) -> Completable {
        return input.do(onError: { print($0) })
    }

    func testApplyCompletable() {
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        // When
        let result = scheduler.start {
            Observable.just(1).ignoreElements().asObservable()
        }
        // Then
        XCTAssertEqual(result.events, Recorded.events([
            .completed(TestScheduler.Defaults.subscribed)
        ]))
    }
}
