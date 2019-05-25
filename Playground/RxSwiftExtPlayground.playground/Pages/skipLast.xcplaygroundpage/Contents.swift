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
 ## skipLast

 `skipLast` suppress the specified number of items emitted by an Observable
 */

example("skipLast") {
    // skip last three elemens
    Observable.of(1, 2, 3, 4, 5, 6)
        .skipLast(3)
        .subscribe { print($0) }
}

//: [Next](@next)
