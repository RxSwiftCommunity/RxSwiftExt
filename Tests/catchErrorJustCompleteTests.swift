//
//  catchErrorJustCompleteTests.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 31/07/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class CatchErrorJustCompleteTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)
    
    func testCatchErrorJustComplete_Empty() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let events : [Recorded<Event<Int>>] = [
            completed(250)]
        let xs = scheduler.createColdObservable(events)
        
        let res = scheduler.start {
            xs.catchErrorJustComplete()
        }
        
        XCTAssertEqual(res.events, [
            completed(450)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450)
            ])
    }

    func testCatchErrorJustComplete_NoError() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            completed(250)
            ])
        
        let res = scheduler.start {
            xs.catchErrorJustComplete()
        }
        
        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            completed(450)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450)
            ])
    }
    
    func testCatchErrorJustComplete_Infinite() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            next(200, 3),
            ])
        
        let res = scheduler.start {
            xs.catchErrorJustComplete()
        }
        
        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            next(400, 3),
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 1000)
            ])
    }
    
    func testCatchErrorJustComplete_Error() {
        let scheduler = TestScheduler(initialClock: 0)
        
        let xs = scheduler.createColdObservable([
            next(100, 1),
            next(150, 2),
            error(250, testError),
            ])
        
        let res = scheduler.start {
            xs.catchErrorJustComplete()
        }
        
        XCTAssertEqual(res.events, [
            next(300, 1),
            next(350, 2),
            completed(450)
            ])
        
        XCTAssertEqual(xs.subscriptions, [
            Subscription(200, 450)
            ])
    }
}
