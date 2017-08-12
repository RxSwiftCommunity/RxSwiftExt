//
//  fromAsyncTests.swift
//  RxSwiftExt
//
//  Created by Vincent on 12/08/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class FromAsyncTests: XCTestCase {
    
    private func service(arg1: String, arg2: Int, completionHandler: (String) -> Void) {
        completionHandler("Result")
    }
    
    func testResultEquality() {
        
        var correct = [Recorded<Event<String>>]()
        
        service(arg1: "Foo", arg2: 0) { result in
            correct.append(next(0, result))
            correct.append(completed(0))
        }
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)
        
        _ = Observable
            .fromAsync(service(arg1:arg2:completionHandler:))("Foo", 2)
            .subscribe(observer)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, correct)
    }
}
