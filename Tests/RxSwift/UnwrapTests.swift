//
//  RxSwiftExtDemoTests.swift
//  RxSwiftExtDemoTests
//
//  Created by Marin Todorov on 4/7/16.
//  Copyright © 2016 Underplot. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class UnwrapTests: XCTestCase {

    let numbers: Array<Int?> = [1, nil, Int?(3), 4]
    fileprivate var observer: TestableObserver<Int>!
    
    override func setUp() {
        super.setUp()
        
        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(numbers)
            .unwrap()
            .subscribe(observer)
        
        scheduler.start()
    }
    
    func testUnwrapFilterNil() {
        //test results count
        XCTAssertEqual(
            observer.events.count,
            numbers.count - 1/* the nr. of nil elements*/ + 1 /* complete event*/
        )
    }
    
    func testUnwrapResultValues() {
        //test elements values and type
        let correctValues = [
            next(0, 1),
            next(0, 3),
            next(0, 4),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correctValues)
    }    
}
