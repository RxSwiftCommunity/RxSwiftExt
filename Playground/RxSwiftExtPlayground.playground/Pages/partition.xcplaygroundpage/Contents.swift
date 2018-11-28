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

example("partition") {
    let numbers = Observable
        .of(1, 2, 3, 5, 8, 13, 18, 21, 23)

    let (evens, odds) = numbers.partition { $0 % 2 == 0 }

    _ = evens.debug("even").subscribe()
    _ = odds.debug("odds").subscribe()
}
//: [Next](@next)

