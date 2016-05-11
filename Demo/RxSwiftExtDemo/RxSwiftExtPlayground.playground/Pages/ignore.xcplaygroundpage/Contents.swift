/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Build `RxSwiftExt` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

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

/*:
 ## ignoreWhen
 
 The `ignoreWhen` operator works like `filter` but ignores the elements for which the predicate returns `true` instead of keeping them.
 */

example("ignore some elements") {
    
    let values = [1, 5, 40, 12, 60, 3, 9, 18]
    
    values.toObservable()
        .ignoreWhen { value in
            return value > 10
        }
        .toArray()
        .subscribeNext() { result in
            // look values on the right panel ===>
            values
            result
            print("ignoreWhen() transformed \(values) to \(result)")
    }
}

//: [Next](@next)
