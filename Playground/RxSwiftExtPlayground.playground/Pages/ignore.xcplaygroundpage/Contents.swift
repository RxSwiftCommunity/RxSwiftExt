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
 ## ignore
 
 The `ignore` operator filters out any of the elements passed in parameters. An alternate implementation of `ignore` is provided, which takes a `SequenceType` with any number of elements to ignore.
 */

example("ignore a single value") {
    
    let values = ["Hello", "Swift", "world"]
    Observable.from(values)
        .ignore("Swift")
        .toArray()
		.subscribe(onNext: { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    })

}

example("ignore multiple values") {
    
	let values = "Hello Swift world we really like Swift and RxSwift".components(separatedBy: " ")
    Observable.from(values)
        .ignore("Swift", "and")
        .toArray()
		.subscribe(onNext: { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    })
    
}

example("ignore a collection of values") {
  
	let values = "Hello Swift world we really like Swift and RxSwift".components(separatedBy: " ")
    let ignoreSet = Set(["and", "Swift"])
    
    Observable.from(values)
        .ignore(ignoreSet)
        .toArray()
		.subscribe(onNext: { result in
            // look values on the right panel ===>
            values
            result
            print("ignore() transformed \(values) to \(result)")
    })

}

/*:
 ## ignoreWhen
 
 The `ignoreWhen` operator works like `filter` but ignores the elements for which the predicate returns `true` instead of keeping them.
 */

example("ignore some elements") {
    
    let values = [1, 5, 40, 12, 60, 3, 9, 18]
    
    Observable.from(values)
        .ignoreWhen { value in
            return value > 10
        }
        .toArray()
		.subscribe(onNext: { result in
            // look values on the right panel ===>
            values
            result
            print("ignoreWhen() transformed \(values) to \(result)")
    })
}

/*:
 ## ignoreErrors
 
 The `ignoreErrors` operator is a synonym for the `retry` operator: it unconditionally ignores any error emitted by the sequence,
 creating an sequence that never fails
 */
enum ExampleError : Error {
    case SeriousError
    case MinorError
}

example("ignore all errors") {

    let subject = PublishSubject<Observable<Int>>()
    
    let _ = subject
        .asObservable()
        .flatMap { $0 }
        .ignoreErrors()
        .subscribe { print($0) }
    
    subject.onNext(Observable.just(1))
    subject.onNext(Observable.just(2))
    subject.onNext(Observable.just(3))
    subject.onNext(Observable.error(ExampleError.SeriousError))
    subject.onNext(Observable.just(4))
    subject.onNext(Observable.just(5))

}

example("ignore only minor errors") {
    
    let subject = PublishSubject<Observable<Int>>()
    
    let _ = subject
        .asObservable()
        .flatMap { $0 }
        .ignoreErrors {
            if case ExampleError.SeriousError = $0 {
                return false
            }
            return true
        }
        .subscribe { print($0) }
    
    subject.onNext(Observable.just(1))
    subject.onNext(Observable.just(2))
    subject.onNext(Observable.just(3))
    subject.onNext(Observable.error(ExampleError.SeriousError))
    subject.onNext(Observable.just(4))
    subject.onNext(Observable.just(5))

}

//: [Next](@next)
