/*:
> # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
1. Build scheme `RxSwiftExt (playground)` scheme for a simulator target
1. Choose `View > Show Debug Area`
*/

//: [Previous](@previous)
import Foundation
import RxSwift
import RxSwiftExt

/*:
## Observable.fromAsync()

This function takes as argument a function that takes up to 9 arbitrary arguments and a completionHandler
and returns a function with the same signature, minus the completionHandler, and returns an Observable with
the same Element type as the completionHandler
*/
example("Turn a completion handler into an observable sequence") {
	func someAsynchronousTask(arg1: String, arg2: Int, completionHandler: @escaping (String) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			completionHandler("completion handler result")
		}
	}

	let observableService = Observable.fromAsync(someAsynchronousTask)
	
	print("Waiting for completion handler to be called...")
	
	_ = observableService("Foo", 0)
		.subscribe(onNext: { (result) in
			print("Asynchronous callback called with: \(result)")
		})

	playgroundShouldContinueIndefinitely()
}
//: [Next](@next)
