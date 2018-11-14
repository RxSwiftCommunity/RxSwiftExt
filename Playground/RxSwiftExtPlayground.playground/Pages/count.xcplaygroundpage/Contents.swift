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
 ## count

 Count the number of items emitted by an Observable
 - seealso: [count operator on reactivex.io](http://reactivex.io/documentation/operators/count.html)
 - parameter predicate: predicate determines what elements to be counted.

 - returns: An Observable sequence containing a value that represents how many elements in the specified observable sequence satisfy a condition if provided, else the count of items.

 */

example("count") {

    // count even number in the sequence
    let _ = Observable.from([1...10])
        .count { $0 % 2 == 0 }
        .subscribe(onNext: {
            print ($0)
        })

}

//: [Next](@next)
