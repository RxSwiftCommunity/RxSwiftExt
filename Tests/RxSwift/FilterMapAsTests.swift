//
//  FilterMapAsTests.swift
//  RxSwiftExt
//
//  Created by Jérôme Alves on 21/02/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class FilterMapAsTests: XCTestCase {
    
    func testFilterMapAsStringFromAny() {

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)

        let values: [Any] = ["Hello", 12, "World", true]

        _ = Observable
            .from(values)
            .filterMap(as: String.self)
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, "Hello"),
            next(0, "World"),
            completed(0)
        ]

        print(observer.events)

        XCTAssertEqual(observer.events, correct)
    }

}
