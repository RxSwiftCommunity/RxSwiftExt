//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwift_Ext

/*:
 ## replaceWith(AnyObject)
 
 The `replaceWith` operator takes a sequence of elements and returns a sequence of the same constant provided as a parameter. In effect it ignores its input and replaces it with a constant
 */
example("replace any input with a value") {
    
    let numbers = Array<Int?>([1, 2, 3])
    numbers.toObservable()
        .replaceWith("candy")
        .toArray()
        .subscribeNext {result in
            // look types on the right panel ===>
            numbers
            result
            print("unwrap() transformed \(numbers) to \(result)")
    }
}


//: [Next](@next)