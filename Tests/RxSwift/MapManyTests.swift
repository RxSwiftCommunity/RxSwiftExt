//
//  MapManyTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 06/05/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwiftExt
import RxSwift
import RxTest

class MapManyTests: XCTestCase {
    func runAndObserve<C: Collection>(_ sequence: Observable<C>) -> TestableObserver<C> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(C.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testMapManyWithModel() {
        // swiftlint:disable:next nesting
        struct SomeModel: CustomStringConvertible {
            let number: Int
            var description: String { return "#\(number)" }

            init(_ number: Int) {
                self.number = number
            }
        }

        let sourceArray = Observable.of(1...4)

        let observer = runAndObserve(sourceArray.mapMany(SomeModel.init))
        let correct = Recorded.events([
            .next(0, [SomeModel(1), SomeModel(2), SomeModel(3), SomeModel(4)]),
            .completed(0)
        ])

        XCTAssertEqual(observer.events.description, correct.description)
    }

    func testMapManyWithInts() {
        let sourceArray = Observable.of(1...10)

        let observer = runAndObserve(sourceArray.mapMany { $0 + 1 })
        let correct = Recorded.events([
            .next(0, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }

    func testMapManyWithStrings() {
        let sourceArray = Observable.just(["a", "b", "C"])

        let observer = runAndObserve(sourceArray.mapMany { ($0 + "x").lowercased() })
        let correct = Recorded.events([
            .next(0, ["ax", "bx", "cx"]),
            .completed(0)
        ])

        XCTAssertEqual(observer.events, correct)
    }
}
