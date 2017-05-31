//
//  filterMapTests.swift
//  RxSwiftExt
//
//  Created by Jeremie Girault on 31/05/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

enum FilterMapTestError: Error {
    case error
}

class FilterMapTests: XCTestCase {
    func testIgnoreEvenAndEvenizeOdds() {

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        let values = 1..<10
        _ = Observable.from(values)
            .filterMap { $0 % 2 == 0 ? .ignore : .map(2*$0) }
            .subscribe(observer)

        scheduler.start()

        var correct = values
            .filter { $0 % 2 != 0 }
            .map { next(0, 2*$0) }
        correct.append(completed(0))

        XCTAssertEqual(observer.events, correct)
    }

    func testErrorsWithSource() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        let subject = PublishSubject<Int>()
        _ = subject
            .filterMap { $0 % 2 == 0 ? .ignore : .map(2*$0) }
            .subscribe(observer)

        subject.on(.next(1))
        subject.on(.next(2))
        subject.on(.next(3))
        subject.on(.error(FilterMapTestError.error))

        scheduler.start()

        let correct = [
            next(0, 2),
            next(0, 6),
            error(0, FilterMapTestError.error)
        ]

        print(observer.events)

        XCTAssertEqual(observer.events, correct)
    }
}
