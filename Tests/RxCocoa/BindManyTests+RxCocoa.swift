//
//  BindManyTests+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Matthew Crenshaw on 7/16/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxSwiftExt

class BindManyTests: XCTestCase {
    func testBindCollection() {
        let values = ["one", "two", "three", "four"]

        let scheduler = TestScheduler(initialClock: 0)
        let observers = [scheduler.createObserver(String.self),
                         scheduler.createObserver(String.self),
                         scheduler.createObserver(String.self),
                         scheduler.createObserver(String.self)]

        _ = Observable.from(values).bind(to: observers)

        scheduler.start()

        let correct = [next(0, "one"),
                       next(0, "two"),
                       next(0, "three"),
                       next(0, "four"),
                       completed(0)]

        for observer in observers {
            XCTAssertEqual(observer.events, correct)
        }
    }
}
