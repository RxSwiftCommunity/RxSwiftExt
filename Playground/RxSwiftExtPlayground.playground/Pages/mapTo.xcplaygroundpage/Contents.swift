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
 ## map(to: Any)
 
 The `map` operator takes a sequence of elements and returns a sequence of the same constant provided as a parameter. In effect it ignores its input and replaces it with a constant
 */
example("replace any input with a value") {
    
    let numbers = Array<Int?>([1, 2, 3])
    Observable.from(numbers)
        .mapTo("candy")
        .toArray()
		.subscribe(onNext: {result in
            // look types on the right panel ===>
            numbers
            result
            print("map(to:) transformed \(numbers) to \(result)")
    })
}


//: [Next](@next)
