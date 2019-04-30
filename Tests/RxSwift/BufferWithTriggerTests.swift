//
//  BufferWithTriggerTests.swift
//  RxSwiftExt
//
//  Created by Patrick Maltagliati on 11/12/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class BufferWithTriggerTests: XCTestCase {
    let testError = NSError(domain: "dummyError", code: -232, userInfo: nil)
    let scheduler = TestScheduler(initialClock: 0)

    func testBuffersUntilBoundaryEmits() {
        let underlying = scheduler.createHotObservable(
            [
                .next(150, 1),
                .next(201, 2),
                .next(230, 3),
                .next(300, 4),
                .next(350, 5),
                .next(375, 6),
                .next(400, 7),
                .next(430, 8),
                .completed(500)
            ]
        )

        let boundary = scheduler.createHotObservable(
            [
                .next(201, ()),
                .next(301, ()),
                .next(401, ())
            ]
        )

        let res = scheduler.start(disposed: 1000) {
            underlying.bufferWithTrigger(boundary.asObservable())
        }

        let expected = Recorded.events([
            .next(201, [2]),
            .next(301, [3, 4]),
            .next(401, [5, 6, 7]),
            .next(500, [8]),
            .completed(500)
        ])

        XCTAssertEqual(res.events, expected)

        XCTAssertEqual(underlying.subscriptions, [Subscription(200, 500)])
    }

    func testPausedError() {
        let underlying = scheduler.createHotObservable(
            [
                .next(150, 1),
                .next(210, 2),
                .error(230, testError),
                .completed(500)
            ]
        )

        let boundary = scheduler.createHotObservable(
            [
                .next(201, ()),
                .next(211, ())
            ]
        )

        let res = scheduler.start(disposed: 1000) {
            underlying.bufferWithTrigger(boundary.asObservable())
        }

        let expected = Recorded.events([
            .next(201, []),
            .next(211, [2]),
            .error(230, testError)
        ])
        XCTAssertEqual(res.events, expected)

        XCTAssertEqual(underlying.subscriptions, [Subscription(200, 230)])
    }
}
