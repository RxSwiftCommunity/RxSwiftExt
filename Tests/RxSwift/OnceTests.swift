//
//  OnceTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 12/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class OnceTests: XCTestCase {
    
    func testOnce() {
        
        let onceObservable = Observable.once("Hello")
        let scheduler = TestScheduler(initialClock: 0)

        let observer1 = scheduler.createObserver(String.self)
        _ = onceObservable.subscribe(observer1)

        let observer2 = scheduler.createObserver(String.self)
        _ = onceObservable.subscribe(observer2)
        
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
    
    func testMultipleOnce() {
        
        let onceObservable1 = Observable.once("Hello")
        let onceObservable2 = Observable.once("world")
        let scheduler = TestScheduler(initialClock: 0)

        let observer1 = scheduler.createObserver(String.self)
        _ = onceObservable1.subscribe(observer1)
        let observer2 = scheduler.createObserver(String.self)
        _ = onceObservable1.subscribe(observer2)

        let observer3 = scheduler.createObserver(String.self)
        _ = onceObservable2.subscribe(observer3)
        let observer4 = scheduler.createObserver(String.self)
        _ = onceObservable2.subscribe(observer4)

        scheduler.start()
        
        let correct1 = [
            next(0, "Hello"),
            completed(0)
        ]
        let correct2 : [Recorded<Event<String>>] = [
            completed(0)
        ]
        let correct3 = [
            next(0, "world"),
            completed(0)
        ]
        let correct4 : [Recorded<Event<String>>] = [
            completed(0)
        ]

        XCTAssertEqual(observer1.events, correct1)
        XCTAssertEqual(observer2.events, correct2)
        XCTAssertEqual(observer3.events, correct3)
        XCTAssertEqual(observer4.events, correct4)

    }
}
