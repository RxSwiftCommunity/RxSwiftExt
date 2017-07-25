//
//  MapToCocoaTests.swift
//  RxSwiftExtDemo
//
//  Created by Rafael Ferreira on 3/7/17.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxCocoa
import RxSwift
import RxSwiftExt
import RxTest

class MapToCocoaTests: XCTestCase {

    let numbers: Array<Int?> = [1, nil, Int?(3)]
    fileprivate var observer: TestableObserver<String>!

    override func setUp() {
        super.setUp()

        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(String.self)

        _ = Observable.from(numbers)
            .asDriver(onErrorJustReturn: nil)
            .map(to: "candy")
            .drive(observer)

        scheduler.start()
    }

    func testReplaceWithResultCount() {
        XCTAssertEqual(
            observer.events.count-1 /*complete event*/,
            numbers.count
        )
    }

    func testReplaceWithResultValues() {
        //test elements values and type
        let correctValues = [
            next(0, "candy"),
            next(0, "candy"),
            next(0, "candy"),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correctValues)
    }
}
