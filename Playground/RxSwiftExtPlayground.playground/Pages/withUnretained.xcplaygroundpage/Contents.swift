/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

class TestClass: CustomStringConvertible {
    var description: String { return "Test Class" }
}

example("withUnretained") {
    var testClass: TestClass! = TestClass()

    _ = Observable
        .of(1, 2, 3, 5, 8, 13, 18, 21, 23)
        .withUnretained(testClass)
        .debug("Combined Object with Emitted Events")
        .do(onNext: { _, value in
            if value == 13 {
                // When testClass becomes nil, the next emission of the original
                // sequence will try to retain it and fail. As soon as it fails,
                // the sequence will complete.
                testClass = nil
            }
        })
        .subscribe()
}
//: [Next](@next)

