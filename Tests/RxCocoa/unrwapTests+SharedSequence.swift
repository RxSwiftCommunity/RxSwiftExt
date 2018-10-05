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
    fileprivate var observer: TestableObserver<Int>!
    fileprivate let numbersVariable = Variable<Int?>(nil)

    override func setUp() {
        super.setUp()

        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Int.self)

        _ =  numbersVariable
                .asDriver()
                .unwrap()
                .asObservable()
                .subscribe(observer)

        _ = Observable.from(numbers)
            .bind(to: numbersVariable)

        scheduler.start()
    }

    func testUnwrapFilterNil() {
        //test results count
        XCTAssertEqual(
            observer.events.count,
            numbers.count - 1/* the nr. of nil elements*/
        )
    }

    func testUnwrapResultValues() {
        //test elements values and type
        let correctValues = [
            next(0, 1),
            next(0, 3),
            next(0, 4)
        ]
        XCTAssertEqual(observer.events, correctValues)
    }
}
