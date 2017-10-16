//
//  ignoreWhenTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 14/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

func isPrime(_ i: Int) -> Bool {
    if i <= 1 {
        return false
    }
    
    let max = Int(sqrt(Double(i)))
    if max <= 1 {
        return true
    }
    
    for j in 2 ... max {
        if i % j == 0 {
            return false
        }
    }
    
    return true
}

class IgnoreWhenTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)
    
    func test_ignoreWhenComplete() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var invoked = 0
        
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600),
            next(610, 12),
            error(620, testError),
            completed(630)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            return xs.ignoreWhen { (num: Int) -> Bool in
                invoked += 1
                return !isPrime(num);
            }
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(340, 5),
            next(390, 7),
            next(580, 11),
            completed(600)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 600)
            ])
        
        XCTAssertEqual(9, invoked)
    }
    
    func test_ignoreWhenFalse() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var invoked = 0
        
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            return xs.ignoreWhen { (num: Int) -> Bool in
                invoked += 1
                return false
            }
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 600)
            ])
        
        XCTAssertEqual(9, invoked)
    }
    
    func test_ignoreWhenTrue() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var invoked = 0
        
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600)
            ])
        
        let res = scheduler.start { () -> Observable<Int> in
            return xs.ignoreWhen { (num: Int) -> Bool in
                invoked += 1
                return true
            }
        }
        
        XCTAssertEqual(res.events, [
            completed(600)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 600)
            ])
        
        XCTAssertEqual(9, invoked)
    }
    
    func test_ignoreWhenDisposed() {
        let scheduler = TestScheduler(initialClock: 0)
        
        var invoked = 0
        
        let xs = scheduler.createHotObservable([
            next(110, 1),
            next(180, 2),
            next(230, 3),
            next(270, 4),
            next(340, 5),
            next(380, 6),
            next(390, 7),
            next(450, 8),
            next(470, 9),
            next(560, 10),
            next(580, 11),
            completed(600)
            ])
        
        let res = scheduler.start(disposed: 400) { () -> Observable<Int> in
            return xs.ignoreWhen { (num: Int) -> Bool in
                invoked += 1
                return !isPrime(num)
            }
        }
        
        XCTAssertEqual(res.events, [
            next(230, 3),
            next(340, 5),
            next(390, 7)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 400)
            ])
        
        XCTAssertEqual(5, invoked)
    }
}
