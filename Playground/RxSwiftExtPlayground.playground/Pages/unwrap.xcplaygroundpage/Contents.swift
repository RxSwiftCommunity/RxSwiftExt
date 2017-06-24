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
 ## unwrap()
 
 The `unwrap` operator takes a sequence of optional elements
 and returns a sequence of non-optional elements, filtering out any `nil` values.
 */
example("unwrap optional values") {
    
    let numbers = Array<Int?>([1, 2, 3])
    Observable.from(numbers)
        .unwrap()
        .toArray()
		.subscribe(onNext: { result in
            // look types on the right panel ===>
            numbers
            result
            print("unwrap() transformed \(numbers) to \(result)")
    })
}

Observable.of(1,2,nil,Int?(4))
    .unwrap()
    .subscribe { print($0) }

example("unwrap and filter out nil values") {
    
    let numbers = [1, 2, nil, Int?(4)]
    Observable.from(numbers)
        .unwrap()
        .toArray()
		.subscribe(onNext: { result in
            // look types on the right panel ===>
            numbers
            result
            print("unwrap() transformed \(numbers) to \(result)")
    })
}

//: [Next](@next)
