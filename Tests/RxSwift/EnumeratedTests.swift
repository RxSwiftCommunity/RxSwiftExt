//
//  EnumeratedTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class EnumeratedTests: XCTestCase {
    fileprivate func runAndObserve<T>(_ sequence: Observable<T>) -> TestableObserver<T> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(T.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testEnumerated() {
        let source = Observable.of(1, 4, 6, 1, 7, 8)

        let indexObservable = source.enumerated().map { $0.index }
        let elementObservable = source.enumerated().map { $0.element }

        let indexObserver = runAndObserve(indexObservable)
        let elementObserver = runAndObserve(elementObservable)

        let correctIndexes = [
            next(0, 0),
            next(0, 1),
            next(0, 2),
            next(0, 3),
            next(0, 4),
            next(0, 5),
            completed(0)
        ]

        let correctElements = [
            next(0, 1),
            next(0, 4),
            next(0, 6),
            next(0, 1),
            next(0, 7),
            next(0, 8),
            completed(0)
        ]

        XCTAssertEqual(indexObserver.events, correctIndexes)
        XCTAssertEqual(elementObserver.events, correctElements)
    }

    
}
