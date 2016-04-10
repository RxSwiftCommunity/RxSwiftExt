//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwift_Ext

/*:
 ## unwrap
 
 The `unwrap` operator takes a sequence of optional elements
 and returns a sequence of non-optional elements, filtering out `nil` values.
 */

let numbers = [1, 2, nil, Int?(4)]

numbers.toObservable()
    .unwrap()
    .toArray()
    .subscribeNext { result in
        // look types on the right panel ===>
        numbers
        result
        print("unwrap() transformed \(numbers) to \(result)")
    }

//: [Next](@next)
