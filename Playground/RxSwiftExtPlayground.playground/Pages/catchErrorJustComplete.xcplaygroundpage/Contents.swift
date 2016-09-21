/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Build `RxSwiftExt` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
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
private enum SampleErrors : ErrorType {
    case fatalError
}

let sampleObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onError(SampleErrors.fatalError)
    observer.onCompleted()
    return NopDisposable.instance
}

example("catchErrorJustComplete") {
    
    let _ = sampleObservable
        .doOnError { print("Source observable emitted error \($0)") }
        .catchErrorJustComplete()
        .subscribe {
            print ("\($0)")
    }
    
}

//: [Next](@next)
