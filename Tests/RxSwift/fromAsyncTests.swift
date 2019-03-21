//
//  FromAsyncTests.swift
//  RxSwiftExt
//
//  Created by Vincent on 12/08/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class FromAsyncTests: XCTestCase {
    private var scheduler: TestScheduler!
    private var observer: TestableObserver<String>!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(String.self)
    }
    
    override func tearDown() {
        scheduler = nil
        observer = nil
        super.tearDown()
    }

    func testResultEquality() {
        var correct = [Recorded<Event<String>>]()

        service(arg1: "Foo", arg2: 0) { result in
            correct.append(next(0, result))
            correct.append(completed(0))
        }

        _ = Observable
            .fromAsync(service(arg1:arg2:completionHandler:))("Foo", 2)
            .subscribe(observer)

        scheduler.start()

        XCTAssertEqual(observer.events, correct)
    }
    
    func testSingleResultEqualitySuccessCase() {
        // given
        let result = "result"
        let expectedEvents: [Recorded<Event<String>>] = [.next(0, result), .completed(0)]
        // when
        _ = Single<String>
            .fromAsync(serviceWithError)(result)
            .asObservable()
            .subscribe(observer)
        scheduler.start()
        // then
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testSingleOptionalResultEqualitySuccessCase() {
        // given
        let result: String? = nil
        let expectedEvents: [Recorded<Event<String?>>] = [.next(0, result), .completed(0)]
        let observer = scheduler.createObserver(Optional<String>.self)
        // when
        _ = Single<String?>
            .fromAsync(serviceWithOptionalResult)(result)
            .asObservable()
            .subscribe(observer)
        scheduler.start()
        // then
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testSingleResultEqualityErrorCase() {
        // given
        let expectedEvents: [Recorded<Event<String>>] = [.error(0, TestError())]
        // when
        _ = Single<String>
            .fromAsync(serviceThrowingError)
            .asObservable()
            .subscribe(observer)
        scheduler.start()
        // then
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    // MARK: - Private utils
    private struct TestError: Error {
    }
    
    private func service(arg1: String, arg2: Int, completionHandler: (String) -> Void) {
        completionHandler("Result")
    }
    
    private func serviceWithError(result: String, completionHandler: (String?, TestError?) -> Void) {
        completionHandler(result, nil)
    }
    
    private func serviceWithOptionalResult(result: String?, completionHandler: (String??, TestError?) -> Void) {
        completionHandler(result, nil)
    }
    
    private func serviceThrowingError(completionHandler: (String?, TestError?) -> Void) {
        completionHandler(nil, TestError())
    }
    
    private func serviceWithOptionalResult(completionHandler: (String??, TestError?) -> Void) {
        completionHandler(.some(nil), nil)
    }
}
