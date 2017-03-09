//
//  notTests+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/7/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxSwiftExt
import RxTest

class NotCocoaTests: XCTestCase {
    func testNot() {
        let values = [true, false, true]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)

        _ = Observable.from(values).asDriver(onErrorJustReturn: false)
            .not()
            .drive(observer)

        scheduler.start()

        let correct = [
            next(0, false),
            next(0, true),
            next(0, false),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }
}
