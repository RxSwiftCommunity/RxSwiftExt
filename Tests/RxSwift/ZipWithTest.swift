//
//  ZipWithTest.swift
//  RxSwiftExt
//
//  Created by Arjan Duijzer on 26/12/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

struct Pair<F: Equatable, S: Equatable> {
    let first: F
    let second: S
}

enum ZipWithTestError: Error {
    case error
}

extension Pair: Equatable {
}

func ==<F, S>(lhs: Pair<F, S>, rhs: Pair<F, S>) -> Bool {
    return lhs.first == rhs.first && lhs.second == rhs.second
}

class ZipWithTest: XCTestCase {
    func testZipWith_SourcesNotEmpty_ZipCompletes() {
        let scheduler = TestScheduler(initialClock: 0)
        let source1 = Observable.from([1, 2, 3])
        let source2 = Observable.from(["a", "b"])

        let res = scheduler.start {
            source1.zip(with: source2) {
                Pair(first: $0, second: $1)
            }
        }

        let expected = [
			next(200, Pair(first: 1, second: "a")),
			next(200, Pair(first: 2, second: "b")),
			completed(200)
		]
        XCTAssertEqual(res.events, expected)
    }

    func testZipWith_SourceEmpty_ZipCompletesEmpty() {
        let scheduler = TestScheduler(initialClock: 0)
        let source1 = Observable.from([1, 2, 3])
        let source2 = Observable<Int>.empty()

        let res = scheduler.start {
            source1.zip(with: source2) {
                Pair(first: $0, second: $1)
            }
        }

        let expected: [Recorded<Event<Pair<Int, Int>>>] = [completed(200)]
        XCTAssertEqual(res.events, expected)
    }

    func testZipWith_SourceError_ZipCompletesWithError() {
        let scheduler = TestScheduler(initialClock: 0)
        let source1 = Observable.just(1)
        let source2 = Observable<Int>.error(ZipWithTestError.error)

        let res = scheduler.start {
            source1.zip(with: source2) {
                Pair(first: $0, second: $1)
            }
        }

        let expected: [Recorded<Event<Pair<Int, Int>>>] = [error(200, ZipWithTestError.error)]
        XCTAssertEqual(res.events, expected)
    }

    func testMaybeZipWith_SourcesNotEmpty_ZipCompletes() {
        let scheduler = TestScheduler(initialClock: 0)
        let source1 = Maybe.just(1)
        let source2 = Observable.from(["a", "b", "c"])

        let res = scheduler.start {
            source1.zip(with: source2) {
                Pair(first: $0, second: $1)
            }
        }

        let expected = [
			next(200, Pair(first: 1, second: "a")),
			completed(200)
		]
        XCTAssertEqual(res.events, expected)
    }

    func testSingleZipWith_SourcesNotEmpty_ZipCompletes() {
        let scheduler = TestScheduler(initialClock: 0)
        let source1 = Single.just(1)
        let source2 = Observable.just(2)

        let res = scheduler.start {
            source1.zip(with: source2) {
                Pair(first: $0, second: $1)
            }
        }

        let expected = [
			next(200, Pair(first: 1, second: 2)),
			completed(200)
		]
        XCTAssertEqual(res.events, expected)
    }
}
