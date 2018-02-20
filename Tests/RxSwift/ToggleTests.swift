//
//  ToggleTests.swift
//  RxSwiftExt
//
//  Created by Vincent on 20/02/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxTest
import RxSwiftExt

class ToggleTests: XCTestCase {
    
    func testStartWithFalse() {
        let originalSequence = Observable.of(1, 2, 3, 4)
        let correct: [Recorded<Event<Bool>>] = [
            next(0, false),
            next(0, true),
            next(0, false),
            next(0, true),
            next(0, false),
            completed(0)]
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        
        _ = originalSequence.toggle(initial: false).subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testStartWithTrue() {
        let originalSequence = Observable.of(1, 2, 3, 4)
        let correct: [Recorded<Event<Bool>>] = [
            next(0, true),
            next(0, false),
            next(0, true),
            next(0, false),
            next(0, true),
            completed(0)]
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)
        
        _ = originalSequence.toggle(initial: true).subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, correct)
    }
}
