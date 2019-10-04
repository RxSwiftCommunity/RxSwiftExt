//
//  UnwrapTests.swift
//  RxSwiftExt
//
//  Created by Hugo Saynac on 05/10/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class UnwrapSharedStrategyTests: XCTestCase {
    let numbers: [Int?] = [1, nil, Int?(3), 4]
    private var observer: TestableObserver<Int>!
    private let numbersSubject = BehaviorSubject<Int?>(value: nil)

    override func setUp() {
        super.setUp()

        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Int.self)

        _ = numbersSubject
                .asDriver(onErrorJustReturn: nil)
                .unwrap()
                .asObservable()
                .subscribe(observer)

        _ = Observable.from(numbers)
            .bind(to: numbersSubject)

        scheduler.start()
    }

    func testUnwrapFilterNil() {
        //test results count
        print(observer.events)
        XCTAssertEqual(
            observer.events.count,
            numbers.count
        )
    }

    func testUnwrapResultValues() {
        // test elements values and type
        let correctValues = Recorded.events(
            .next(0, 1),
            .next(0, 3),
            .next(0, 4),
            .completed(0)
        )
        XCTAssertEqual(observer.events, correctValues)
    }
}
