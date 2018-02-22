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

/*:
 ## filterMap(as:)

 The `filterMap(as:)` operator filters the items emitted by the source observable, only emitting those of the given type.
 */
example("filters the items, only emitting those of the given type") {

    let values: [Any] = ["Hello", 12, "World", true]

    Observable.from(values)
        .filterMap(as: String.self)
        .toArray()
        .subscribe(onNext: { result in
            print(result)
        })
}



//: [Next](@next)

