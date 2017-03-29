//
//  MaterializeTests.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 1/5/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

// This is a hack needed to make XCTAssertEqual work for Observables of Recorded<Event<Event<T>>
extension Event: Equatable { }

public func ==<T>(a: Event<T>, b: Event<T>) -> Bool {
    switch (a, b) {
    case let (.next(a), .next(b)):
        // Is it ugly? Yes. Does it work? Yes.
        let ae = a as! NSObject
        let be = b as! NSObject
        return ae == be
    case let (.error(err1), .error(err2)):
        let e1 = err1 as NSError,
        e2 = err2 as NSError
        return e1 == e2
    case (.completed, .completed): return true
    default: return false
    }
}

enum MaterializeError: Error {
    case anError
}

class MaterializeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMaterialize() {
        let values = [0, 42, -7, 100, 1000, 1]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Event<Int>.self)

        _ = Observable.from(values)
            .materialize()
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, Event.next(0)),
            next(0, Event.next(42)),
            next(0, Event.next(-7)),
            next(0, Event.next(100)),
            next(0, Event.next(1000)),
            next(0, Event.next(1)),
            next(0, Event.completed),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testDematerialize() {
        let values = [0, 42, -7, 100, 1000, 1]

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.from(values)
            .materialize()
            .dematerialize()
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, 0),
            next(0, 42),
            next(0, -7),
            next(0, 100),
            next(0, 1000),
            next(0, 1),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testMaterializeError() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Event<Int>.self)

        _ = Observable.error(MaterializeError.anError)
            .startWith(42)
            .materialize()
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, Event.next(42)),
            next(0, Event.error(MaterializeError.anError)),
            completed(0)
        ]

        XCTAssertEqual(observer.events, correct)
    }

    func testDematerializeError() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)

        _ = Observable.error(MaterializeError.anError)
            .startWith(42)
            .materialize()
            .dematerialize()
            .subscribe(observer)

        scheduler.start()

        let correct = [
            next(0, 42),
            error(0, MaterializeError.anError)
        ]

        XCTAssertEqual(observer.events, correct)
    }
}
