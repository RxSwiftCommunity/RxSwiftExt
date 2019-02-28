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

    func testOverridingScanInt() {
        let scheduler = TestScheduler(initialClock: 0)
        let overridingObservable = scheduler.createHotObservable([
            next(400, 10),
            completed(500)
            ])
        let observable = scheduler.createHotObservable([
            next(300, 2),
            next(350, 3),
            next(450, 4),
            completed(550)
            ])
        let res = scheduler.start {
            return observable.overridingScan(overridingObservable, 0) { (total, current) -> Int in
                return total + current
            }
        }
        let correct = [
            next(300, 2),
            next(350, 5),
            next(400, 10),
            next(450, 14),
            completed(550)
        ]
        XCTAssertEqual(res.events, correct)
    }

    func testOverridingScanArray() {
        let scheduler = TestScheduler(initialClock: 0)
        let overridingObservable = scheduler.createHotObservable([
            next(250, [1]),
            next(400, [2, 4]),
            completed(550)
            ])
        let observable = scheduler.createHotObservable([
            next(300, [3, 6]),
            next(350, [7]),
            next(450, [22, 8]),
            completed(500)
            ])
        let res = scheduler.start {
            return observable.overridingScan(overridingObservable, []) { (total, current) -> [Int] in
                return total + current
            }
        }
        let correct = [
            next(250, [1]),
            next(300, [1, 3, 6]),
            next(350, [1, 3, 6, 7]),
            next(400, [2, 4]),
            next(450, [2, 4, 22, 8]),
            completed(550)
        ]
        XCTAssertEqual(res.events, correct)
    }

}
