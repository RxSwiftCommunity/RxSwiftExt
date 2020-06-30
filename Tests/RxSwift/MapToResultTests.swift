//
//  MapToResultTests.swift
//  RxSwiftExt-iOS
//
//  Created by 이병찬 on 2020/06/30.
//  Copyright © 2020 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import RxTest
import XCTest
import RxSwiftExt

class MapToResultTests: XCTestCase {
    private var scheduler = TestScheduler(initialClock: 0)

    override func setUp() {
        super.setUp()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    func testMapToResult_noHandler() {
        let observable = scheduler.createColdObservable([
            .next(10, "value1"),
            .next(20, "value2"),
            .error(30, CustomError.error)
        ])
        let observer = scheduler.createObserver(Result<String, CustomError>.self)

        _ = observable.mapToResult(errorType: CustomError.self).bind(to: observer)

        scheduler.start()

        XCTAssertEqual(observer.events, Recorded.events([
            .next(10, .success("value1")),
            .next(20, .success("value2")),
            .next(30, .failure(CustomError.error)),
            .completed(30),
        ]))
    }

    func testMapToResult_handler() {
        let observable = scheduler.createColdObservable([
            .next(10, "value1"),
            .next(20, "value2"),
            .error(30, UnexpectedError.error)
        ])
        let observer = scheduler.createObserver(Result<String, CustomError>.self)

        _ = observable.mapToResult(errorType: CustomError.self) { unexpectedError in
            if case UnexpectedError.error = unexpectedError {
                XCTAssert(true)
            }
            return .just(.failure(CustomError.error))
        }
        .bind(to: observer)

        scheduler.start()

        XCTAssertEqual(observer.events, Recorded.events([
            .next(10, .success("value1")),
            .next(20, .success("value2")),
            .next(30, .failure(CustomError.error)),
            .completed(30),
        ]))
    }

    func testMapToResult_justReturn() {
        let observable = scheduler.createColdObservable([
            .next(10, "value1"),
            .next(20, "value2"),
            .error(30, UnexpectedError.error)
        ])
        let observer = scheduler.createObserver(Result<String, CustomError>.self)

        _ = observable
            .mapToResult(catchErrorCastingFailedJustReturn: CustomError.error)
            .bind(to: observer)

        scheduler.start()

        XCTAssertEqual(observer.events, Recorded.events([
            .next(10, .success("value1")),
            .next(20, .success("value2")),
            .next(30, .failure(CustomError.error)),
            .completed(30),
        ]))
    }
}

private enum CustomError: Error {
    case error
}

private enum UnexpectedError: Error {
    case error
}
