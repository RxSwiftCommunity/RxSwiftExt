//
//  WithUnretainedTests.swift
//  RxSwiftExt
//
//  Created by Vincent Pradeilles on 28/03/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

private class Displayer {
    let deinitAction: (() -> Void)?

    init(deinitAction: (() -> Void)? = nil) {
        self.deinitAction = deinitAction
    }

    deinit {
        deinitAction?()
    }

    func display(_ value: Any) {
        print(value)
    }
}

class WithUnretainedTests: XCTestCase {
    func test_unretained_gets_deallocated() {
        // Test constants
        let valuesToBeObserved = [1, 2, 3, 5, 8]
        let valuesToBeIgnored = [13, 21]

        // Test flags
        var displayerWasDeallocated = false
        var valuesObserved = [Int]()

        // Object to be safely unowned
        var displayer: Displayer? = Displayer(deinitAction: {
            displayerWasDeallocated = true
        })

        let publishSubject = PublishSubject<Int>()

        if let displayer = displayer {
            _ = publishSubject
                .withUnretained(displayer) // -> Observable<(Displayer, Int)>
                .subscribe(onNext: { displayer, i in
                    displayer.display(i)
                    valuesObserved.append(i)
                })
        }

        valuesToBeObserved.forEach { publishSubject.onNext($0) }
        displayer = nil
        valuesToBeIgnored.forEach { publishSubject.onNext($0) }
        publishSubject.onCompleted()

        XCTAssertTrue(displayerWasDeallocated)
        XCTAssertEqual(valuesObserved, valuesToBeObserved)
    }

    func test_sequence_completes() {
        // Test constants
        let valuesToBeObserved = [1, 2, 3, 5, 8]
        let valuesToBeIgnored = [13, 21]

        // Test flags
        var outerSequenceHasCompleted = false
        var valuesObserved = [Int]()

        // Object to be safely unowned
        var displayer: Displayer? = Displayer()

        let publishSubject = PublishSubject<Int>()

        if let displayer = displayer {
            _ = publishSubject
                .withUnretained(displayer) // -> Observable<(Displayer, Int)>
                .debug()
                .subscribe(onNext: { displayer, i in
                    displayer.display(i)
                    valuesObserved.append(i)
                }, onError: nil,
                   onCompleted: {
                    outerSequenceHasCompleted = true
                }, onDisposed: nil)
        }

        valuesToBeObserved.forEach { publishSubject.onNext($0) }
        displayer = nil
        valuesToBeIgnored.forEach { publishSubject.onNext($0) }

        XCTAssertTrue(outerSequenceHasCompleted)
        XCTAssertEqual(valuesObserved, valuesToBeObserved)
    }
}
