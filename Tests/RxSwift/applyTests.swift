//
//  applyTests.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 2/22/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class applyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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

        let correct = [
            next(0, 42*42),
            next(0, 100*100),
            next(0, 1000*1000),
            next(0, 1*1),
            completed(0)
        ]

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

        let correct = [
            next(0, "0"),
            next(0, "42"),
            next(0, "-7"),
            next(0, "100"),
            next(0, "1000"),
            next(0, "1"),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }
}
