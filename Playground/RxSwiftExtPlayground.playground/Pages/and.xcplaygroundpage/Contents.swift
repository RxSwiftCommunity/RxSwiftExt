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

example("Combine observables using the .and(...) operator") {
    
    let bool = Observable.just(true)
	let boolsWithFalse: [Observable<Bool>] = [.just(true), .just(true), .just(true), .just(false)]
	let boolsWithoutFalse: [Observable<Bool>] = [.just(true), .just(true), .just(true)]
    let outputFalse = bool.and(boolsWithFalse)
	let outputTrue = bool.and(boolsWithoutFalse)

    outputFalse.subscribe(onNext: { value in
        print("output when one or more is false = \(value)")
    })

	outputTrue.subscribe(onNext: { value in
		print("output when all are true = \(value)")
	})
}

//: [Next](@next)
