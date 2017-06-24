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
 ## distinct
 
 Suppress duplicate items emitted by an Observable
 - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
 - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.

 */

example("distinct") {
    
    // suppress duplicate strings from the sequence
    let _ = Observable.of("a","b","a","c","b","a","d")
        .distinct()
		.subscribe(onNext: {
            print ("\($0)")
        })
    
}

//: [Next](@next)
