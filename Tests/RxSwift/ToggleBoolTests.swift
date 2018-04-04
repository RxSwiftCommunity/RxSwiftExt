//
//  ToggleBoolTests.swift
//  RxSwiftExt
//
//  Created by Vincent on 20/02/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxTest
import RxSwiftExt

class ToggleBoolTests: XCTestCase {
    
    var values: TestableObservable<Int>!
    let scheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        super.setUp()
        
        values = scheduler.createColdObservable([
            .next(215, 1),
            .next(220, 2),
            .next(225, 3),
            .next(230, 4),
            .completed(250)
            ])
    }
    
    func testStartWithFalse() {
        let correct: [Recorded<Event<Bool>>] = [
            next(200, false),
            next(415, true),
            next(420, false),
            next(425, true),
            next(430, false),
            completed(450)
        ]
        
        let res = scheduler.start {
            self.values
                .toggleBool(initial: false)
        }
        
        XCTAssertEqual(res.events, correct)
    }
    
    func testStartWithTrue() {
        let correct: [Recorded<Event<Bool>>] = [
            next(200, true),
            next(415, false),
            next(420, true),
            next(425, false),
            next(430, true),
            completed(450)
        ]
        
        let res = scheduler.start {
            self.values
                .toggleBool(initial: true)
        }
        
        XCTAssertEqual(res.events, correct)
    }
}
