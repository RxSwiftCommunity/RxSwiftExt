//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwift_Ext

/*:
 ## ignore
 
 The `ignore` operator filters out any of the elements passed in parameters. An alternate implementation of `ignore` is provided, which takes a `SequenceType` with any number of elements to ignore.
 */

example("ignore a single value") {
    
    let values = ["Hello", "Swift", "world"]
    values.toObservable()
        .ignore("Swift")
        .toArray()
        .subscribeNext { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    }

}

example("ignore multiple values") {
    
    let values = "Hello Swift world we really like Swift and RxSwift".componentsSeparatedByString(" ")
    values.toObservable()
        .ignore("Swift", "and")
        .toArray()
        .subscribeNext { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    }
    
}

example("ignore a collection of values") {
  
    let values = "Hello Swift world we really like Swift and RxSwift".componentsSeparatedByString(" ")
    let ignoreSet = Set(["and", "Swift"])
    
    values.toObservable()
        .ignore(ignoreSet)
        .toArray()
        .subscribeNext { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    }

}

//: [Next](@next)
