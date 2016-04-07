//: Build the current target before running the playground

import Foundation
import RxSwift
import RxSwift_Ext

//: unwrap() is an operator that transforms a [Element?] observable to [Element]
//: all nil values are filtered in the process

let numbers = [1, 2, nil, Int?(4)]

numbers.toObservable()
    .unwrap()
    .reduce([]) {unwrapped, element in
        return unwrapped + [element]
    }
    .subscribeNext {result in
        numbers
        result
    }
