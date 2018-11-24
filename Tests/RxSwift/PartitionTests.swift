//
//  PartitionTests.swift
//  RxSwiftExt
//
//  Created by Shai Mishali on 24/11/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift
import RxTest
import XCTest
import RxSwiftExt

class PartitionTests: XCTestCase {
    private var scheduler = TestScheduler(initialClock: 0)
    private var stream: TestableObservable<Int>!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        let events = (0...10).map { i -> Recorded<Event<Int>> in
            return .next(i * 10, i)
        } + [.completed(100)]

        stream = scheduler.createHotObservable(events)
    }

    func testPartitionBothMatch() {
        let (evens, odds) = stream.partition { $0 % 2 == 0 }

        let evensObserver = scheduler.createObserver(Int.self)
        _ = evens.bind(to: evensObserver)

        let oddsObserver = scheduler.createObserver(Int.self)
        _ = odds.bind(to: oddsObserver)

        scheduler.start()

        XCTAssertEqual(oddsObserver.events, Recorded.events([
            .next(10, 1),
            .next(30, 3),
            .next(50, 5),
            .next(70, 7),
            .next(90, 9),
            .completed(100)
        ]))

        XCTAssertEqual(evensObserver.events, Recorded.events([
            .next(0, 0),
            .next(20, 2),
            .next(40, 4),
            .next(60, 6),
            .next(80, 8),
            .next(100, 10),
            .completed(100)
        ]))
    }

    func testPartitionOneSideMatch() {
        let (all, none) = stream.partition { $0 <= 10 }

        let allObserver = scheduler.createObserver(Int.self)
        _ = all.bind(to: allObserver)

        let noneObserver = scheduler.createObserver(Int.self)
        _ = none.bind(to: noneObserver)

        scheduler.start()

        XCTAssertEqual(allObserver.events, Recorded.events([
            .next(0, 0),
            .next(10, 1),
            .next(20, 2),
            .next(30, 3),
            .next(40, 4),
            .next(50, 5),
            .next(60, 6),
            .next(70, 7),
            .next(80, 8),
            .next(90, 9),
            .next(100, 10),
            .completed(100)
        ]))

        XCTAssertEqual(noneObserver.events, [.completed(100)])
    }
}
