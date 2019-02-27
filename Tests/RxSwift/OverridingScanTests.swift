//
//  OverridingScanTests.swift
//  RxSwiftExt
//
//  Created by Sergey Smagleev on 02/27/19.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class OverridingScanTests: XCTestCase {

    func testOverridingScan() {
        let scheduler = TestScheduler(initialClock: 0)

        let overridingObservable = scheduler.createHotObservable([
            next(250, 1),
            next(400, 10),
            completed(500)
            ])

        let observable = scheduler.createHotObservable([
            next(300, 2),
            next(350, 3),
            next(450, 4),
            completed(500)
            ])

        let res = scheduler.start {
            return observable.overridingScan(overridingObservable, 0) { (total, current) -> Int in
                return total + current
            }
        }

        let correct = [
            next(250, 1),
            next(300, 3),
            next(350, 6),
            next(400, 10),
            next(450, 14),
            completed(500)
        ]

        XCTAssertEqual(res.events, correct)
    }

}
