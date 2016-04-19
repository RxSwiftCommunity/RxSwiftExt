//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwift_Ext

/*:
 ## not

 The `not` operator applies a the boolean not (!) to a `Bool`
 */
example("boolean not") {

    _ = Observable.just(false)
        .not()
        .subscribeNext { result in
            assert(result)
    }
}


//: [Next](@next)
