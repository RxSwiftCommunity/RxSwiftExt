//
//  distinct+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/8/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxSwiftExt

class DistinctCocoaTests: XCTestCase {
    func testDistinctHashableOne() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let values = [DummyHashable(id: 1, name: "SomeName")]

            let errored = DummyHashable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyHashable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored).distinct().drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyHashable(id: 1, name: "SomeName")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctHashableTwo() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let values = [DummyHashable(id: 1, name: "SomeName"),
                          DummyHashable(id: 2, name: "SomeName2"),
                          DummyHashable(id: 1, name: "SomeName")]

            let errored = DummyHashable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyHashable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored).distinct().drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyHashable(id: 1, name: "SomeName")),
                next(0, DummyHashable(id: 2, name: "SomeName2")),
                completed(0)
            ]

            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctHashableEmpty() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let errored = DummyHashable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyHashable.self)

            _ = Observable<DummyHashable>.empty().asDriver(onErrorJustReturn: errored)
                .distinct().drive(observer)

            scheduler.start()

            let correct: [Recorded<Event<DummyHashable>>] = [
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctEquatableOne() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let values = [DummyEquatable(id: 1, name: "SomeName")]
            let value = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: value)
                .distinct().drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctEquatableTwo() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let values = [DummyEquatable(id: 1, name: "SomeName"),
                          DummyEquatable(id: 2, name: "SomeName2"),
                          DummyEquatable(id: 1, name: "SomeName")]

            let errored = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored).distinct().drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName")),
                next(0, DummyEquatable(id: 2, name: "SomeName2")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctEquatableEmpty() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let errored = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable<DummyEquatable>.empty().asDriver(onErrorJustReturn: errored).distinct().drive(observer)

            scheduler.start()

            let correct: [Recorded<Event<DummyEquatable>>] = [
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctPredicateOne() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let values = [DummyEquatable(id: 1, name: "SomeName1"),
                          DummyEquatable(id: 2, name: "SomeName2"),
                          DummyEquatable(id: 3, name: "SomeName1")]

            let errored = DummyEquatable(id: 0, name: "SomeName0")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored)
                .distinct {
                    $0.name.contains("1")
                }.drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName1")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctPredicateAll() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) { 
            let values = [DummyEquatable(id: 1, name: "SomeName1"),
                          DummyEquatable(id: 2, name: "SomeName2"),
                          DummyEquatable(id: 3, name: "SomeName3")]

            let errored = DummyEquatable(id: 0, name: "SomeName0")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored)
                .distinct {
                    $0.name.contains("T")
                }.drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName1")),
                next(0, DummyEquatable(id: 2, name: "SomeName2")),
                next(0, DummyEquatable(id: 3, name: "SomeName3")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctPredicateEmpty() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {
            let errored = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable<DummyEquatable>.empty().asDriver(onErrorJustReturn: errored)
                .distinct {
                    $0.id < 0
                }
                .drive(observer)

            scheduler.start()

            let correct: [Recorded<Event<DummyEquatable>>] = [
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctPredicateFirst() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) { 
            let values = [DummyEquatable(id: 1, name: "SomeName1"),
                          DummyEquatable(id: 2, name: "SomeName2"),
                          DummyEquatable(id: 3, name: "SomeName3")]

            let errored = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored)
                .distinct {
                    $0.id > 0
                }.drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName1")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }

    func testDistinctPredicateTwo() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) { 
            let values = [DummyEquatable(id: 1, name: "SomeName1"),
                          DummyEquatable(id: 2, name: "SomeName2"),
                          DummyEquatable(id: 3, name: "SomeName3")]

            let errored = DummyEquatable(id: 0, name: "NoneName")
            let observer = scheduler.createObserver(DummyEquatable.self)

            _ = Observable.from(values).asDriver(onErrorJustReturn: errored)
                .distinct {
                    $0.id > 1
                }.drive(observer)

            scheduler.start()

            let correct = [
                next(0, DummyEquatable(id: 1, name: "SomeName1")),
                next(0, DummyEquatable(id: 2, name: "SomeName2")),
                completed(0)
            ]
            
            XCTAssertEqual(observer.events, correct)
        }
    }
}
