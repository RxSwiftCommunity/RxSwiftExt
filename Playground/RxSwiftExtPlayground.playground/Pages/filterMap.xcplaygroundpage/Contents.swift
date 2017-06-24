/*:
> # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
1. Build scheme `RxSwiftExt (playground)` scheme for a simulator target
1. Choose `View > Show Debug Area`
*/

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

/*:
## filterMap()

A common pattern in Rx is to filter out some values, then map the remaining ones to something else. The `filterMap` operator does this in one step:
*/

example("filterMap") {
	// keep only odd numbers and double them
	Observable.of(1,2,3,4,5,6)
		.filterMap { number in
			return (number % 2 == 0) ? .ignore : .map(number * 2)
		}
		.subscribe { print($0) }
}

//: [Next](@next)
