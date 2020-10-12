//
//  FlatScanTests.swift
//  RxSwiftExt
//
//  Created by Jérôme Alves (Datadog) on 09/10/2020.
//  Copyright © 2020 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

// MARK: - Flat Scan

class FlatScanTests: XCTestCase {

    func test_Empty() {
        test(
            operator: { $0.flatScan },
            elementsAccumulator: { _, _ in [] },
            expectedEvents: [
                .completed(200 + 200)
            ]
        )
    }

    func test_Chronologic_Events() {
        test(
            operator: { $0.flatScan },
            elementsAccumulator: { accumulated, element in [
                .next(10, (accumulated) + (element) + 1),
                .next(20, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                .next(200 + 110, (seed) + (10) + 1),
                .next(200 + 120, (seed) + (10) + 2),
                .next(200 + 210, (seed + 10 + 2) + (20) + 1),
                .next(200 + 220, (seed + 10 + 2) + (20) + 2),
                .completed(200 + 220)
            ]
        )
    }

    func test_Mixed_Events() {
        test(
            operator: { $0.flatScan },
            elementsAccumulator: { accumulated, element in [
                .next(50, (accumulated) + (element) + 1),
                .next(200, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                // First and Second Observable are mixed
                .next(200 + 150, (seed) + (10) + 1),
                .next(200 + 250, (seed + 10 + 1) + (20) + 1),
                .next(200 + 300, (seed) + (10) + 2),
                .next(200 + 400, (seed + 10 + 1) + (20) + 2),
                .completed(200 + 400)
            ]
        )
    }

}

// MARK: - Flat Scan First

class FlatScanFirstTests: XCTestCase {

    func test_Empty() {
        test(
            operator: { $0.flatScanFirst },
            elementsAccumulator: { _, _ in [] },
            expectedEvents: [
                .completed(200 + 200)
            ]
        )
    }

    func test_Chronologic_Events() {
        test(
            operator: { $0.flatScanFirst },
            elementsAccumulator: { accumulated, element in [
                .next(10, (accumulated) + (element) + 1),
                .next(20, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                .next(200 + 110, (seed) + (10) + 1),
                .next(200 + 120, (seed) + (10) + 2),
                .next(200 + 210, (seed + 10 + 2) + (20) + 1),
                .next(200 + 220, (seed + 10 + 2) + (20) + 2),
                .completed(200 + 220)
            ]
        )
    }

    func test_Mixed_Events() {
        test(
            operator: { $0.flatScanFirst },
            elementsAccumulator: { accumulated, element in [
                .next(50, (accumulated) + (element) + 1),
                .next(200, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                .next(200 + 150, (seed) + (10) + 1),
                .next(200 + 300, (seed) + (10) + 2),
                // Second Observable is skipped
                .completed(200 + 300)
            ]
        )
    }

}

// MARK: - Flat Scan Latest

class FlatScanLatestTests: XCTestCase {

    func test_Empty() {
        test(
            operator: { $0.flatScanLatest },
            elementsAccumulator: { _, _ in [] },
            expectedEvents: [
                .completed(200 + 200)
            ]
        )
    }

    func test_Chronologic_Events() {
        test(
            operator: { $0.flatScanLatest },
            elementsAccumulator: { accumulated, element in [
                .next(10, (accumulated) + (element) + 1),
                .next(20, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                .next(200 + 110, (seed) + (10) + 1),
                .next(200 + 120, (seed) + (10) + 2),
                .next(200 + 210, (seed + 10 + 2) + (20) + 1),
                .next(200 + 220, (seed + 10 + 2) + (20) + 2),
                .completed(200 + 220)
            ]
        )
    }

    func test_Mixed_Events() {
        test(
            operator: { $0.flatScanLatest },
            elementsAccumulator: { accumulated, element in [
                .next(50, (accumulated) + (element) + 1),
                .next(200, (accumulated) + (element) + 2),
            ]},
            expectedEvents: [
                .next(200 + 150, (seed) + (10) + 1),
                // First Observable is disposed
                .next(200 + 250, (seed + 10 + 1) + (20) + 1),
                .next(200 + 400, (seed + 10 + 1) + (20) + 2),
                .completed(200 + 400)
            ]
        )
    }
}

// MARK: - Abstraction

private let seed = 42

private typealias FlatScan<T> = (_ seed: T, _ accumulator: @escaping (T, T) -> Observable<T>) -> Observable<T>

private func test(
    operator flatScan: @escaping (Observable<Int>) -> FlatScan<Int>,
    elementsAccumulator: @escaping (Int, Int) -> [Recorded<Event<Int>>],
    expectedEvents: [Recorded<Event<Int>>],
    file: StaticString = #file,
    line: UInt = #line
) {
    let scheduler = TestScheduler(initialClock: 0)

    let xs = scheduler.createColdObservable([
        .next(100, 10),
        .next(200, 20),
        .completed(200)
    ])

    let flatScan = flatScan(xs.asObservable())

    let result = scheduler.start {
        flatScan(seed) { accumulated, element in
            var elements = elementsAccumulator(accumulated, element)
            if let last = elements.last {
                elements.append(.completed(last.time))
            } else {
                elements.append(.completed(0)) // Empty
            }
            return scheduler.createColdObservable(elements).asObservable()
        }
    }
    XCTAssertEqual(result.events, expectedEvents, file: file, line: line)
}
