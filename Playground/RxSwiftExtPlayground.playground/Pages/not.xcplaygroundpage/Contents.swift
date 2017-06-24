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
 ## not

 The `not` operator applies a the boolean not (!) to a `Bool`
 */
example("boolean not - example 1") {

    _ = Observable.just(false)
        .not()
		.subscribe(onNext: { result in
            assert(result)
			print("Success! result = \(result)")
        })
}

//: [Next](@next)
