//
//  CountTests.swift
//  RxSwiftExt
//
//  Created by Fred on 06/11/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class CountTests: XCTestCase {
    func testCountOne() {
        let value = 0
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from([value])
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 1),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountJust() {
        let value = 1
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.just(value)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 1),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountOf() {
        let value = 2
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.of(value)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 1),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountArrayOne() {
        let values = [3, 4]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 2),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountArrayTwo() {
        let values = [5, 6, 7]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.just(values)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 1),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountArrayEmpty() {
        let values = [Int]()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 0),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountNestedArray() {
        let values = [[8], [9, 10], [11, 12, 13, 14]]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count()
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 3),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountPredicateEmptyOne() {
        let values = [15, 16, 17]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count { $0 > 20 }
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 0),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountPredicateEmptyTwo() {
        let values = [Int]()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count { $0 < 10 }
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 0),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountPredicatePartial() {
        let values = [18, 19, 20, 21]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count { $0 % 2 == 0 }
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 2),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testCountPredicateAll() {
        let values = [22, 23, 24, 25]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .count { $0 > 20 }
            .subscribe(observer)

        scheduler.start()

        let correct = Recorded.events([
            .next(0, 4),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }
}
