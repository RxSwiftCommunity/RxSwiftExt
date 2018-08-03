//
//  NonPollingBufferTests.swift
//  RxSwiftExt
//
//  Created by Brian Semiglia on 07/31/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest
import RxBlocking

class NonPollingBufferTests: XCTestCase {

    let cleanup = DisposeBag()

    func testSingleFlush() {

        var output = [[Int]]()

        Observable
            .just(1)
            .delay(0.0, scheduler: MainScheduler.instance)
            .nonPollingBuffer(timeSpan: 1, capacity: 5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { x in
                output += [x]
            })
            .disposed(by: cleanup)

        let x = expectation(description: "")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.1,
            execute: {
                XCTAssertEqual(output, [[1]])
                x.fulfill()
            }
        )
        waitForExpectations(timeout: 10)
    }

    func testMultipleFlushes() {

        var output = [[Int]]()

        Observable
            .merge([
                Observable.just(1).delay(0.0, scheduler: MainScheduler.instance),
                Observable.just(2).delay(0.9, scheduler: MainScheduler.instance),
                Observable.just(3).delay(1.0, scheduler: MainScheduler.instance),
                Observable.just(4).delay(1.5, scheduler: MainScheduler.instance)
            ])
            .nonPollingBuffer(timeSpan: 1, capacity: 5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { x in
                output += [x]
            })
            .disposed(by: cleanup)

        let x = expectation(description: "")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.51,
            execute: {
                XCTAssertEqual(output, [[1, 2], [3, 4]])
                x.fulfill()
            }
        )
        waitForExpectations(timeout: 10)
    }

    func testSingleCapacityFlush() {

        var output = [[Int]]()

        Observable
            .merge([
                Observable.just(1).delay(0.00, scheduler: MainScheduler.instance),
                Observable.just(2).delay(0.25, scheduler: MainScheduler.instance)
            ])
            .nonPollingBuffer(
                timeSpan: 0.5,
                capacity: 2,
                scheduler: MainScheduler.instance
            )
            .subscribe(onNext: { x in
                output += [x]
            })
            .disposed(by: cleanup)

        let x = expectation(description: "")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.51,
            execute: {
                XCTAssertEqual(output, [[1, 2]])
                x.fulfill()
            }
        )
        waitForExpectations(timeout: 10)
    }

    func testMultipleCapacityFlush() {

        var output = [[Int]]()

        Observable
            .merge([
                Observable.just(1).delay(0.00, scheduler: MainScheduler.instance),
                Observable.just(2).delay(0.25, scheduler: MainScheduler.instance),
                Observable.just(3).delay(0.75, scheduler: MainScheduler.instance),
                Observable.just(4).delay(1.00, scheduler: MainScheduler.instance)
                ])
            .nonPollingBuffer(
                timeSpan: 1.25,
                capacity: 2,
                scheduler: MainScheduler.instance
            )
            .subscribe(onNext: { x in
                output += [x]
            })
            .disposed(by: cleanup)

        let x = expectation(description: "")
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.251,
            execute: {
                XCTAssertEqual(output, [[1, 2], [3, 4]])
                x.fulfill()
            }
        )
        waitForExpectations(timeout: 10)
    }

}
