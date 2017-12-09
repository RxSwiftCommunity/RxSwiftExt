//
//  nwiseTests.swift
//  RxSwiftExt
//
//  Created by Zsolt Váradi on 2017. 12. 09..
//  Copyright © 2017. RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class nwiseTests: XCTestCase {
    func testNwiseEmitsGroups() {
        let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EquatableArray<Int>.self)

        _ = Observable.from(values)
            .nwise(3)
            .map(EquatableArray.init)
            .subscribe(observer)

        scheduler.start()

        let correct: [Recorded<Event<EquatableArray<Int>>>] = [
            next(0, EquatableArray([1, 2, 3])),
            next(0, EquatableArray([2, 3, 4])),
            next(0, EquatableArray([3, 4, 5])),
            next(0, EquatableArray([4, 5, 6])),
            next(0, EquatableArray([5, 6, 7])),
            next(0, EquatableArray([6, 7, 8])),
            next(0, EquatableArray([7, 8, 9])),
            next(0, EquatableArray([8, 9, 10])),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testNwiseCompletesWithNotEnoughElements() throws {
        let values = [1, 2]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EquatableArray<Int>.self)

        _ = Observable.from(values)
            .nwise(3)
            .map(EquatableArray.init)
            .subscribe(observer)

        scheduler.start()

        let correct: [Recorded<Event<EquatableArray<Int>>>] = [
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testNwiseForwardsError() throws {
        let subject = PublishSubject<Int>()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EquatableArray<Int>.self)

        _ = subject.nwise(3)
            .map(EquatableArray.init)
            .subscribe(observer)

        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        subject.onError(DummyError.expected)
        scheduler.start()

        let correct: [Recorded<Event<EquatableArray<Int>>>] = [
            next(0, EquatableArray([1, 2, 3])),
            next(0, EquatableArray([2, 3, 4])),
            error(0, DummyError.expected)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testPairwise() throws {
        let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let scheduler = TestScheduler(initialClock: 0)

        // XCTAssertEqual + Recorded doesn't work with Int tuples,
        // so values are mapped Strings instead as a workaround.
        let observer = scheduler.createObserver(String.self)

        _ = Observable.from(values)
            .pairwise()
            .map { "\($0.0) \($0.1)"}
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, "1 2"),
            next(0, "2 3"),
            next(0, "3 4"),
            next(0, "4 5"),
            next(0, "5 6"),
            next(0, "6 7"),
            next(0, "7 8"),
            next(0, "8 9"),
            next(0, "9 10"),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testPairwiseCompletesWithNotEnoughElements() throws {
        let values = [1]
        let scheduler = TestScheduler(initialClock: 0)

        let observer = scheduler.createObserver(String.self)

        _ = Observable.from(values)
            .pairwise()
            .map { "\($0.0) \($0.1)"}
            .subscribe(observer)

        scheduler.start()

        let correct: [Recorded<Event<String>>] = [
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testPairwiseForwardsError() throws {
        let subject = PublishSubject<Int>()
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(String.self)

        _ = subject.pairwise()
            .map { "\($0.0) \($0.1)" }
            .subscribe(observer)

        subject.onNext(1)
        subject.onNext(2)
        subject.onNext(3)
        subject.onNext(4)
        subject.onError(DummyError.expected)
        scheduler.start()

        let correct = [
            next(0, "1 2"),
            next(0, "2 3"),
            next(0, "3 4"),
            error(0, DummyError.expected)
        ]

        XCTAssertEqual(observer.events, correct)
    }
}

private enum DummyError: Error {
    case expected
}

private struct EquatableArray<Element: Equatable> : Equatable {
    let elements: [Element]
    init(_ elements: [Element]) {
        self.elements = elements
    }
}

private func ==<E>(lhs: EquatableArray<E>, rhs: EquatableArray<E>) -> Bool {
    return lhs.elements == rhs.elements
}
