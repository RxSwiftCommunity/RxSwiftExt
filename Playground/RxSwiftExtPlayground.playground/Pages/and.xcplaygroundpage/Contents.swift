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

example("Ensure that only `true` values are emitted") {
	let allTrue = Observable.of(true, true ,true)
	let allTrue2 = Observable.just(true)
	let someFalse = Observable.of(true, false, true)
	let empty = Observable<Bool>.empty()

	allTrue.and().subscribe { result in
		print("- when all values are true, we get a `true` Maybe: \(result)")
	}

	someFalse.and().subscribe { result in
		print("- when some values are false, we get a `false` Maybe: \(result)")
	}

	empty.and().subscribe { result in
		print("- when no value is emitted, we get a Maybe with no result: \(result)")
	}

	Observable.and(allTrue, empty).subscribe { result in
		print("- mixing an empty sequence and a sequence of true values, we get a `true` Maybe: \(result)")
	}

	Observable.and(allTrue, someFalse, empty).subscribe { result in
		print("- mixing an empty sequence and sequences of true and false values, we get a `false` Maybe: \(result)")
	}

	Observable.and(allTrue, allTrue2).subscribe { result in
		print("- mixing sequences of true values, we get a `true` Maybe: \(result)")
	}
}

//: [Next](@next)
