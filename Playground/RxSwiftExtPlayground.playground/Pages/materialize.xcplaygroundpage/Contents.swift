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
 ## materialize()

 The `materialize` operator takes a sequence of elements and returns a sequence of Event<T>, with Error and Completed events explicitly represented. The returned sequence never errors out, though it might complete.

 The `dematerialize` operator performs the inverse operation, taking a sequence of Event<T> and returning a sequence of T. If the underlying operator has elements of type Event.error or Event.completed, the dematerialized sequence errors or completes, respectively.
 
 - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)
 */
example("materialize a sequence") {
    let numbers = [1, 2, 3]
    print("materialize() transformed \(numbers) to sequence of Events: ")
    let materialized = Observable.from(numbers).materialize()
    materialized.subscribe{ result in
        print(result)
    }
    print("\n...and dematerialize() transformed it back: ")
    materialized.dematerialize().subscribe { result in
        print(result)
    }
}

example("materialize errors") {
    enum MyErrors: Error {
        case AnError(input: Int)
    }
    // Simulate a network request with a 50% chance of failure
    func myRequest(input: Int) -> Observable<Int> {
        if arc4random() % 2 == 0 {
            return Observable.just(input)
        }
        return Observable.error(MyErrors.AnError(input: input))
    }
    let materialized = Observable<Int>.range(start: 0, count: 10)
        .flatMap { input -> Observable<Event<Int>> in
            return myRequest(input: input).materialize()
        }
        .publish()
     // For cold observables, each subscription to the materialized sequence results in the underlying sequences being regenerated. For hot observables that is not an issue. We use `publish` to turn this cold observable into a hot one.
    materialized.elements().subscribe(onNext: { result in
        print("Successful request: \(result)")
    })
    materialized.errors().subscribe(onNext: { result in
        print("Unsuccessful request: \(result)")
    })
    materialized.connect()
}

//: [Next](@next)
