//
//  WeakTests.swift
//  RxSwiftExtDemo
//
//  Created by Ian Keen on 17/04/2016.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class WeakTests: XCTestCase {
    var target: WeakTarget<Int>?
    var events = [RxEvent: Int]()
    let source = PublishSubject<Int>()
    
    override func setUp() {
        super.setUp()
        
        self.events = [RxEvent: Int]()
        XCTAssertTrue(WeakTargetReferenceCount == 0)
        self.target = WeakTarget<Int>(obs: self.source) {
            self.events = $0
        }
        XCTAssertTrue(WeakTargetReferenceCount == 1)
    }
    override func tearDown() {
        super.tearDown()
        self.target = nil
        
        //If a retain cycle was present this would not return to 0
        XCTAssertTrue(WeakTargetReferenceCount == 0)
    }
    
    //MARK: - Evetn Subscriber
    func testSubscribe() {
        self.target?.useSubscribe()
        
        self.source.onNext(0)
        self.source.onNext(0)
        self.target = nil
        self.source.onNext(0)
        self.source.onError(WeakTargetError.error)
        self.target?.dispose()
        
        let expected: [RxEvent: Int] = [.next: 2, .error: 0, .completed: 0, .disposed: 0]
        XCTAssertTrue(events == expected)
    }
    
    //MARK: - Individual Subscribers
    func testSubscribeNext() {
        self.target?.useSubscribeNext()
        
        self.source.onNext(0)
        self.source.onNext(0)
        self.target = nil
        self.source.onNext(0)
        
        //if a retain cycle was present the .Next count would be 3
        let expected: [RxEvent: Int] = [.next: 2, .error: 0, .completed: 0, .disposed: 0]
        XCTAssertTrue(events == expected)
    }
    
    func testSubscribeError() {
        self.target?.useSubscribeError()
        
        self.source.onError(WeakTargetError.error)
        self.target = nil
        
        //errors only emit once...
        let expected: [RxEvent: Int] = [.next: 0, .error: 1, .completed: 0, .disposed: 0]
        XCTAssertTrue(events == expected)
    }
    
    func testSubscribeCompleted() {
        self.target?.useSubscribeComplete()
        
        self.source.onCompleted()
        self.target = nil
        
        //completed only emit once...
        let expected: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 1, .disposed: 0]
        XCTAssertTrue(events == expected)
    }
    
    //MARK: - Multi Subscribers
    func testSubscribeOn_Next() {
        self.target?.useSubscribeMulti()
        
        self.source.onNext(0)
        self.source.onNext(0)
        self.target = nil
        self.source.onNext(0)
        
        //if a retain cycle was present the .Next count would be 3
        let expected: [RxEvent: Int] = [.next: 2, .error: 0, .completed: 0, .disposed: 0]
        XCTAssertTrue(events == expected)
    }
    
    func testSubscribeOn_Error() {
        self.target?.useSubscribeMulti()
        
        self.source.onError(WeakTargetError.error)
        self.target = nil
        
        //errors only emit once...
        let expected: [RxEvent: Int] = [.next: 0, .error: 1, .completed: 0, .disposed: 1]
        XCTAssertTrue(events == expected)
    }
    
    func testSubscribeOn_Completed() {
        self.target?.useSubscribeMulti()
        
        self.source.onCompleted()
        self.target = nil
        
        //completed only emit once...
        let expected: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 1, .disposed: 1]
        XCTAssertTrue(events == expected)
    }
    
    func testSubscribeOn_Disposed() {
        self.target?.useSubscribeMulti()
        
        self.target?.dispose()
        self.target = nil
        
        //completed only emit once...
        let expected: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 0, .disposed: 1]
        XCTAssertTrue(events == expected)
    }
}
