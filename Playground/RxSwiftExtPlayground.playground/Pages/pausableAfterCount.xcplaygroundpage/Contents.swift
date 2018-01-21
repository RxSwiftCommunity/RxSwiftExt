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
 ## pausableAfterCount

 The `pausable` operator pauses the elements of the source observable sequence based on the latest element from the second observable sequence.
 The pause is available only after a certain count of events. Before the number of emitted events reaches that count
 the Pauser will not be taken care of.
 - elements from the underlying observable sequence are emitted if and only if the second sequence has most recently emitted `true`.
 */

example("pausableAfterCount") {

    let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

    let trueAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in true }
    let falseAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in false }
    let pauser = Observable.of(trueAtThreeSeconds, falseAtFiveSeconds).merge()

    let pausedObservable = observable.pausable(afterCount: 2, withPauser: pauser)

    pausedObservable
        .subscribe { print($0) }

    playgroundShouldContinueIndefinitely()

}
//: [Next](@next)
