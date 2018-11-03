//
//  FlatMapManyTests.swift
//  RxSwiftExt-iOS
//
//  Created by Yuto Akiba on 2018/11/03.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class FlatMapManyTests: XCTestCase {
    func runAndObserve<C: Collection>(_ sequence: Observable<C>) -> TestableObserver<C> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(C.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testFlatMapMany() {
        let sourceArray = Observable.of(1...4)
        let observer = runAndObserve(sourceArray.flatMapMany(fetch))
        let correct = [
            next(0, ["1", "2", "3", "4"]),
            completed(0)
        ]

        XCTAssertEqual(observer.events.description, correct.description)
    }

    private func fetch(num: Int) -> Observable<String> {
        return Observable.just("\(num)")
    }
}
