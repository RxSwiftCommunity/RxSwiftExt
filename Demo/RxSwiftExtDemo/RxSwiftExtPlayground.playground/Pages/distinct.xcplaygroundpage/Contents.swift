/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Build `RxSwift+Ext` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwift_Ext

/*:
 ## distinct
 
 Suppress duplicate items emitted by an Observable
 - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
 - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.

 */

example("distinct") {
    
    // suppress duplicate strings from the sequence
    let _ = ["a","b","a","c","b","a","d"]
        .toObservable()
        .distinct()
        .subscribeNext {
            print ("\($0)")
        }
    
}

//: [Next](@next)
