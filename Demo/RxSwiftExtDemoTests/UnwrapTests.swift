//
//  RxSwiftExtDemoTests.swift
//  RxSwiftExtDemoTests
//
//  Created by Marin Todorov on 4/7/16.
//  Copyright © 2016 Underplot. All rights reserved.
//

import XCTest

import RxSwift
import RxSwift_Ext
import RxTests

class UnwrapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testUnwrap() {
        let numbers: Array<Int?> = [1,nil,Int?(3),4]
        let scheduler = TestScheduler(initialClock: 0)
        
        let observer = scheduler.createObserver(Int)
        
        numbers.toObservable()
            .unwrap()
            .subscribe(observer)
        
        scheduler.start()
        
        //test elements count
        XCTAssertEqual(observer.events.count, numbers.count - 1/* the nr. of nil elements*/ + 1 /* complete event*/)
    }
    
}