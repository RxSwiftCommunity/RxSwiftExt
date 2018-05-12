//
//  MergeWithTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 28/05/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

enum MergeWithError: Error {
    case error
}

class MergeWithTests: XCTestCase {
    fileprivate func runAndObserve<T>(_ sequence: Observable<T>) -> TestableObserver<T> {
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(T.self)
        _ = sequence.asObservable().subscribe(observer)
        scheduler.start()
        return observer
    }

    func testMergeWith_Numbers() {
        let oddNumbers = [1, 3, 5, 7, 9]
        let evenNumbers = [2, 4, 6, 8, 10]

        let oddStream = Observable.from(oddNumbers)
        let evenStream = Observable.from(evenNumbers)

        let observer1 = runAndObserve(oddStream.merge(with: evenStream))
        let observer2 = runAndObserve(evenStream.merge(with: oddStream))

        let correct1 = Recorded.events([
            .next(0, 1),
            .next(0, 2),
            .next(0, 3),
            .next(0, 4),
            .next(0, 5),
            .next(0, 6),
            .next(0, 7),
            .next(0, 8),
            .next(0, 9),
            .next(0, 10),
            .completed(0)
        ])

        let correct2 = Recorded.events([
            .next(0, 2),
            .next(0, 1),
            .next(0, 4),
            .next(0, 3),
            .next(0, 6),
            .next(0, 5),
            .next(0, 8),
            .next(0, 7),
            .next(0, 10),
            .next(0, 9),
            .completed(0)
        ])

        XCTAssertEqual(observer1.events, correct1)
        XCTAssertEqual(observer2.events, correct2)
    }

    func testMergeWith_Error() {
        let numberStream = Observable.from([1, 2, 3, 4])
        let errorStream = Observable<Int>.error(MergeWithError.error)

        let observer = runAndObserve(numberStream.merge(with: errorStream))

        let expected = Recorded<Event<Int>>.events([.error(0, MergeWithError.error)])

        XCTAssertEqual(observer.events, expected)
    }
}
