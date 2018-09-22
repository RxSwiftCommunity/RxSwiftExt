//
//  IfEmptySwitchToErrorTests.swift
//  RxSwiftExt
//
//  Created by Thibault Wittemberg on 21/09/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxSwiftExt
import RxBlocking

enum SwitchToSingleWithError: Error {
    case completedError
}

class IfEmptySwitchToErrorTests: XCTestCase {

    func testMaybe_TriggerErrorWhenEmpty() {

        // Given: a Maybe that only completes
        let maybeThatCompletes = Maybe<Bool>.create { (observer) -> Disposable in
            observer(.completed)
            return Disposables.create()
        }

        do {
            // When: observing that Maybe
            _ = try maybeThatCompletes
                .ifEmpty(switchToSingleWithError: SwitchToSingleWithError.completedError)
                .toBlocking().single()
        } catch {
            // Then: the underlying single triggers the specified error
            guard case SwitchToSingleWithError.completedError = error else {
                XCTFail("Maybe has not triggered the right Error")
                return
            }
        }
    }

    func testMaybe_TriggerSingleWhenNotEmpty() {

        // Given: a Maybe that succeeds
        let maybeThatSucceeds = Maybe<Bool>.create { (observer) -> Disposable in
            observer(.success(true))
            return Disposables.create()
        }

        // When: observing that Maybe
        let value = try? maybeThatSucceeds
            .ifEmpty(switchToSingleWithError: SwitchToSingleWithError.completedError)
            .toBlocking().single()

        // Then: the value is well triggered by the underlying Single, no error is thrown
        XCTAssertNotNil(value)
        XCTAssert(value!)
    }

}
