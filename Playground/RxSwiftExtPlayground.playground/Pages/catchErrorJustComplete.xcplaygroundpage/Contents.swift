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
 ## catchErrorJustComplete
 
 Dismiss errors and complete the sequence instead
 
 - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
 */
private enum SampleErrors : Error {
    case fatalError
}

let sampleObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onError(SampleErrors.fatalError)
    observer.onCompleted()
    return Disposables.create()
}

example("catchErrorJustComplete") {

    let _ = sampleObservable
		.do(onError: { print("Source observable emitted error \($0)") })
        .catchErrorJustComplete()
        .subscribe {
            print ("\($0)")
    }

}

//: [Next](@next)
