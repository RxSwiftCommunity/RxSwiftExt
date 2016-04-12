//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwift_Ext

/*:
 ## Observable.once
 
 The `Observable.once` function creates a sequence that delivers an element *once* to the first subscriber then completes. The same sequence will complete immediately without delivering any element to all further subscribers.
 
 It lets you guarantee a single-time delivery of a value. Most of the time you will want to use the `Observable.just` operator (creates a sequence which delivers a single element to any observer then complete). In some cases, `Observable.once` can be useful.
 */

let justOnce = Observable.once("Hello, world")

// let's subscribe a first time
justOnce.subscribe { event in
    switch event {
    case .Next(let value):
        print("First subscriber received value \"\(value)\"")
    case .Completed:
        print("First subscriber completed")
    default:
        break
    }
}

// let's subscribe a second time to the SAME sequence
justOnce.subscribe { event in
    switch event {
    case .Next(let value):
        // this will never be reached
        print("Second subscriber received value \"\(value)\"")
    case .Completed:
        print("Second subscriber completed")
    default:
        break
    }
}

//: [Next](@next)
