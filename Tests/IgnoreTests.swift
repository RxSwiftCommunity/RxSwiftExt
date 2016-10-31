//
//  IgnoreTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class IgnoreTests: XCTestCase {
    
    func testIgnoreWithStringArray() {
        
        let values = ["Hello", "Swift", "world"]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)
        
        _ = Observable.from(values)
            .ignore("Swift")
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, "Hello"),
            next(0, "world"),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testIgnoreWithOneElement() {

        let values = [1,2,3,4,5,1,3,5,7,9]
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(values)
            .ignore(3)
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, 1),
            next(0, 2),
            next(0, 4),
            next(0, 5),
            next(0, 1),
            next(0, 5),
            next(0, 7),
            next(0, 9),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testIgnoreWithMultipleElements() {
        
        let values = [1,2,3,4,5,1,3,5,7,9]
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(values)
            .ignore(3,1,9)
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, 2),
            next(0, 4),
            next(0, 5),
            next(0, 5),
            next(0, 7),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testIgnoreWithSequenceType() {

        let values = [1,2,3,4,5,1,3,5,7,9]
        let sequence = Set([3,1,9])
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(values)
            .ignore(sequence)
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, 2),
            next(0, 4),
            next(0, 5),
            next(0, 5),
            next(0, 7),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testIgnoreWithArray() {
        let values = [1,2,3,4,5,1,3,5,7,9]
        let sequence = [3,1,9]
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(values)
            .ignore(sequence)
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, 2),
            next(0, 4),
            next(0, 5),
            next(0, 5),
            next(0, 7),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }

    func testIgnoreWithEmptySequence() {
        let values = [1,2,3,4,5,1,3,5,7,9]
        let emptySequence : [Int] = []
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        _ = Observable.from(values)
            .ignore(emptySequence)
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, 1),
            next(0, 2),
            next(0, 3),
            next(0, 4),
            next(0, 5),
            next(0, 1),
            next(0, 3),
            next(0, 5),
            next(0, 7),
            next(0, 9),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
}
