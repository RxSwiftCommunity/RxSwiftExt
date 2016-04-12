//
//  OnceTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 12/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwift_Ext
import RxTests

class OnceTests: XCTestCase {
    
    func testOnce() {
        
        let onceObservable = Observable.once("Hello")
        let scheduler = TestScheduler(initialClock: 0)

        let observer1 = scheduler.createObserver(String)
        onceObservable.subscribe(observer1)

        let observer2 = scheduler.createObserver(String)
        onceObservable.subscribe(observer2)
        
        scheduler.start()
        
        let correct1 = [
            next(0, "Hello"),
            completed(0)
        ]
        let correct2 : [Recorded<Event<String>>] = [
            completed(0)
        ]
        
        XCTAssertEqual(observer1.events, correct1)
        XCTAssertEqual(observer2.events, correct2)
    }
}
