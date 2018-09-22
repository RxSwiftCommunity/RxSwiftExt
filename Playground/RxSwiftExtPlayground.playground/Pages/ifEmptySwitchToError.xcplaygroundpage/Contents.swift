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
 ## ifEmpty(switchToSingleWithError:)
 In case The Maybe is empty, it is transformed in a Single that immediately triggers an Error

 */

enum SwitchToSingleWithError: Error {
    case completedError
}

example("Maybe switched to Error if empty") {

    Maybe<Bool>.create(subscribe: { (observer) -> Disposable in
        observer(.completed)
        return Disposables.create()
    })
        .ifEmpty(switchToSingleWithError: SwitchToSingleWithError.completedError)
        .subscribe(onSuccess: { (value) in
            print ("The value will never be emitted since the Maybe completes")
        }, onError: { (error) in
            print ("The completed event is transformed into this error: \(error)")
        })
}

//: [Next](@next)
