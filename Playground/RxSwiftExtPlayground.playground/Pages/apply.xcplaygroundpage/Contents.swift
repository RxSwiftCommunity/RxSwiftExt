/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwiftExt

/*:
 ## apply

 The `apply` operator takes a transformation function `(Observable) -> Observable` and applies it to the stream. The purpose of this operator is to provide syntactic sugar for applying multiple operators to the stream, while preserving the chaining operator structure of Rx.

 */

func addOne(input: Observable<Int>) -> Observable<String> {
    return input
        .map { $0 + 1 }
        .map { "The next number is \($0)" }
}

example("apply a transformation") {
    let numbers1 = Observable.from([1, 2, 3])
    let numbers2 = Observable.from([100, 101, 102])

    print("apply() calls the transform function on the Observable sequence: ")

    let transformed1 = numbers1.apply(addOne)
    let transformed2 = numbers2.apply(addOne)

    transformed1.subscribe(onNext: { result in
        print(result)
    })

    transformed2.subscribe(onNext: { result in
        print(result)
    })
}

//: [Next](@next)
