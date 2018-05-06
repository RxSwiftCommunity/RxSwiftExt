//
//  MapManyTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 06.05.18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class MapManyTests: XCTestCase {
    fileprivate func runAndObserve<C: Collection>(_ sequence: Observable<C>) -> TestableObserver<C> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(C.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testMapManyWithInts() {
        let sourceArray = Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

        let observer = runAndObserve(sourceArray.mapMany { $0 + 1 })
        let correct = [
            next(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }

    func testMapManyWithStrings() {
        let sourceArray = Observable.just(["a", "b", "C"])

        let observer = runAndObserve(sourceArray.mapMany { ($0 + "x").lowercased() })
        let correct = [
            next(0, ["ax", "bx", "cx"]),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }
}
