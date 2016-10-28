//
//  DistinctTests.swift
//  RxSwiftExtDemo
//
//  Created by Segii Shulga on 5/4/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxSwiftExt


struct  DummyHashable: Hashable {
    let id: Int
    let name: String
    
    var hashValue: Int {
        return id.hashValue ^ name.hashValue
    }
}

struct DummyEquatable: Equatable {
    let id: Int
    let name: String
}

func == (lhs: DummyEquatable, rhs: DummyEquatable) -> Bool {
    return (lhs.name == rhs.name) && (lhs.id == rhs.id)
}

func == (lhs: DummyHashable, rhs: DummyHashable) -> Bool {
    return (lhs.name == rhs.name) && (lhs.id == rhs.id)
}

class DistinctTests: XCTestCase {
    
    func testDistinctHashableOne() {
        let values = [DummyHashable(id: 1, name: "SomeName")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyHashable.self)
        
        _ = Observable.from(values)
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, DummyHashable(id: 1, name: "SomeName")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctHashableTwo() {
        let values = [DummyHashable(id: 1, name: "SomeName"),
                      DummyHashable(id: 2, name: "SomeName2"),
                      DummyHashable(id: 1, name: "SomeName")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyHashable.self)
        
        _ = Observable.from(values)
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, DummyHashable(id: 1, name: "SomeName")),
            next(0, DummyHashable(id: 2, name: "SomeName2")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctHashableEmpty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyHashable.self)
        
        _ = Observable<DummyHashable>.empty()
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct: [Recorded<Event<DummyHashable>>] = [
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctEquatableOne() {
        let values = [DummyEquatable(id: 1, name: "SomeName")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
        _ = Observable.from(values)
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctEquatableTwo() {
        let values = [DummyEquatable(id: 1, name: "SomeName"),
                      DummyEquatable(id: 2, name: "SomeName2"),
                      DummyEquatable(id: 1, name: "SomeName")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
        _ = Observable.from(values)
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName")),
            next(0, DummyEquatable(id: 2, name: "SomeName2")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }

    func testDistinctEquatableEmpty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
        _ = Observable<DummyEquatable>.empty()
            .distinct()
            .subscribe(observer)
        
        scheduler.start()
        
        let correct: [Recorded<Event<DummyEquatable>>] = [
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctPredicateOne() {
        let values = [DummyEquatable(id: 1, name: "SomeName1"),
                      DummyEquatable(id: 2, name: "SomeName2"),
                      DummyEquatable(id: 3, name: "SomeName1")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
		_ = Observable.from(values)
			.distinct {
				$0.name.contains("1")
			}.subscribe(observer)
		
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName1")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctPredicateAll() {
        let values = [DummyEquatable(id: 1, name: "SomeName1"),
                      DummyEquatable(id: 2, name: "SomeName2"),
                      DummyEquatable(id: 3, name: "SomeName3")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
		_ = Observable.from(values)
			.distinct {
				$0.name.contains("T")
			}.subscribe(observer)
		
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName1")),
            next(0, DummyEquatable(id: 2, name: "SomeName2")),
            next(0, DummyEquatable(id: 3, name: "SomeName3")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctPredicateEmpty() {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
		_ = Observable<DummyEquatable>.empty()
            .distinct {
                $0.id < 0
            }
            .subscribe(observer)
        
        scheduler.start()
        
        let correct: [Recorded<Event<DummyEquatable>>] = [
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }

    func testDistinctPredicateFirst() {
        let values = [DummyEquatable(id: 1, name: "SomeName1"),
                      DummyEquatable(id: 2, name: "SomeName2"),
                      DummyEquatable(id: 3, name: "SomeName3")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
		_ = Observable.from(values)
			.distinct {
				$0.id > 0
			}.subscribe(observer)
		
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName1")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
    
    func testDistinctPredicateTwo() {
        let values = [DummyEquatable(id: 1, name: "SomeName1"),
                      DummyEquatable(id: 2, name: "SomeName2"),
                      DummyEquatable(id: 3, name: "SomeName3")]
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(DummyEquatable.self)
        
		_ = Observable.from(values)
			.distinct {
				$0.id > 1
			}.subscribe(observer)
		
        scheduler.start()
        
        let correct = [
            next(0, DummyEquatable(id: 1, name: "SomeName1")),
            next(0, DummyEquatable(id: 2, name: "SomeName2")),
            completed(0)
        ]
        
        XCTAssertEqual(observer.events, correct)
    }
}
