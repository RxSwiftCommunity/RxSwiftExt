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

 The `filterMap(as:)` operator takes a sequence of elements and returns a filtered sequence of elements casted as given type.
 */
example("map input as the given type and filter other types") {

    let values: [Any] = ["Hello", 12, "World", true]

    Observable.from(values)
        .filterMap(as: String.self)
        .toArray()
        .subscribe(onNext: { result in
            print(result)
        })
}



//: [Next](@next)

