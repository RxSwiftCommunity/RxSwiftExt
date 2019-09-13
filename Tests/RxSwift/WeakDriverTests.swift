//
//  WeakDriverTests.swift
//  RxSwiftExt
//
//  Created by George Kiriy on 13/09/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import XCTest

import RxSwift
import RxCocoa
import RxSwiftExt
import RxTest

class WeakDriverTests: XCTestCase {
    typealias TargetType = WeakTarget<Int, Driver<Int>>
    var target: TargetType?
    var events = [RxEvent: Int]()
    let source = PublishSubject<Int>()

    override func setUp() {
        super.setUp()

        self.events = [RxEvent: Int]()
        XCTAssertTrue(getReferenceCount(for: TargetType.self) == 0)
        self.target = .init(sequence: self.source.asDriver(onErrorJustReturn: 0)) {
            self.events = $0
        }
        XCTAssertTrue(getReferenceCount(for: TargetType.self) == 1)
    }

    override func tearDown() {
        super.tearDown()
        self.target = nil

        // If a retain cycle was present this would not return to 0
        XCTAssertTrue(getReferenceCount(for: TargetType.self) == 0)
        resetReferenceCount(for: TargetType.self)
    }

    // MARK: - Multiple Subscribers
    func testSubscribeOn_Next() {
        self.target?.useDriveMulti()

        self.source.onNext(0)
        self.source.onNext(0)
        self.target = nil
        self.source.onNext(0)

        // If a retain cycle was present, the .next count would be 3
        let expected: [RxEvent: Int] = [.next: 2, .error: 0, .completed: 0, .disposed: 0]
        XCTAssertTrue(events == expected)
    }

    func testSubscribeOn_Completed() {
        self.target?.useDriveMulti()

        self.source.onCompleted()
        self.target = nil

        // completed only emit once
        let expected: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 1, .disposed: 1]
        XCTAssertTrue(events == expected)
    }

    func testSubscribeOn_Disposed() {
        self.target?.useDriveMulti()

        self.target?.dispose()
        self.target = nil

        // Completed only emit once
        let expected: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 0, .disposed: 1]
        XCTAssertTrue(events == expected)
    }
}
