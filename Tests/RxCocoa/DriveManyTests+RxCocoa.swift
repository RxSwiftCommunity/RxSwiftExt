//
//  DriveManyTests+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Matthew Crenshaw on 7/19/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxSwiftExt

class DriveManyTests: XCTestCase {
    func testDriveMany() {
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)

        SharingScheduler.mock(scheduler: scheduler) {

            let values = ["one", "two", "three", "four"]

            let observers = [scheduler.createObserver(String.self),
                             scheduler.createObserver(String.self),
                             scheduler.createObserver(String.self),
                             scheduler.createObserver(String.self)]

            guard let disposable = Driver.from(values).drive(observers) as? CompositeDisposable else {
                XCTFail("expected CompositeDisposable")
                return
            }

            XCTAssertEqual(observers.count, disposable.count)

            scheduler.start()

            let correct = [next(0, "one"),
                           next(0, "two"),
                           next(0, "three"),
                           next(0, "four"),
                           completed(0)]

            for observer in observers {
                XCTAssertEqual(observer.events, correct)
            }

            disposable.dispose()
            XCTAssertTrue(disposable.isDisposed)
        }
    }
}
