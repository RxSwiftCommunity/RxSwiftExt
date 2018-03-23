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
 ## ofType()
 
 The `ofType` operator filters the elements of an observable sequence, if that is an instance of the supplied type.

 */

example("ofType") {
    Observable.of(NSNumber(value: 1),
                  NSDecimalNumber(string: "2"),
                  NSNumber(value: 3),
                  NSNumber(value: 4),
                  NSDecimalNumber(string: "5"),
                  NSNumber(value: 6))
        .ofType(NSDecimalNumber.self)
        .subscribe { print($0) }
}

//: [Next](@next)
