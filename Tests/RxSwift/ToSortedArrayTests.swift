//
//  ToSortedArrayTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 28/04/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class ToSortedArrayTests: XCTestCase {
    fileprivate func runAndObserve<T: Sequence>(_ sequence: Observable<T>) -> TestableObserver<T> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(T.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testDefaultToSortedArray() {
        let source = Observable.of(1, 4, 6, 1, 7, 8)
        let observer = runAndObserve(source.toSortedArray())
        let correct = [
            next(0, [1, 1, 4, 6, 7, 8]),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correct)
    }

    func testAscCase() {
        let source = Observable.of(1, 4, 6, 1, 7, 8)
        let observer = runAndObserve(source.toSortedArray(ascending: true))
        let correct = [
            next(0, [1, 1, 4, 6, 7, 8]),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correct)
    }

    func testDescCase() {
        let source = Observable.of(1, 4, 6, 1, 7, 8)
        let observer = runAndObserve(source.toSortedArray(ascending: false))
        let correct = [
            next(0, [8, 7, 6, 4, 1, 1]),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correct)
    }
}
