//
//  MapToKeyPath.swift
//  RxSwiftExt
//
//  Created by Michael Avila on 2/8/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxSwiftExt
import RxTest

class MapAtTests: XCTestCase {
    struct Person {
        let name: String
    }

    let people: [Person] = [
        Person(name: "Bart"),
        Person(name: "Lisa"),
        Person(name: "Maggie")
    ]

    private var observer: TestableObserver<String>!

    override func setUp() {
        let scheduler = TestScheduler(initialClock: 0)
        observer = scheduler.createObserver(String.self)

        _ = Observable.from(people)
            .mapAt(\.name)
            .subscribe(observer)

        scheduler.start()
    }

    func testResultSequenceHasSameNumberOfItemsAsSourceSequence() {
        XCTAssertEqual(
            observer.events.count - 1, // completed event
            people.count
        )
    }

    func testResultSequenceHasValuesAtProvidedKeypath() {
        //test elements values and type
        let correctValues = [
            next(0, "Bart"),
            next(0, "Lisa"),
            next(0, "Maggie"),
            completed(0)
        ]
        XCTAssertEqual(observer.events, correctValues)
    }
}
