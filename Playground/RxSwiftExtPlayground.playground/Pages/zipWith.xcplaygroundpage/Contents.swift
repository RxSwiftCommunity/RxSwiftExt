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
 ## zip(with:)
 Merges the specified observable sequences into one observable sequence by using the selector function whenever all
 of the observable sequences have produced an element at a corresponding index.

 */
example("zip values") {
	let numbers = [1,2,3]
	let strings = ["a", "b", "c"]

	let first = Observable.from(numbers)
	let second = Observable.from(strings)

	first.zip(with: second) { i, s in
		s + String(i)
	}
		.toArray()
		.subscribe(onNext: { result in
			print("zip(with:) merged \(numbers) with \(strings) to \(result)")
		})
}

//: [Next](@next)
