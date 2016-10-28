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
## pausable

The `pausable` operator pauses the elements of the source observable sequence based on the latest element from the second observable sequence.
- elements from the underlying observable sequence are emitted if and only if the second sequence has most recently emitted `true`.
*/

example("pausable") {
	
	let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
	
	let trueAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in true }
	let falseAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in false }
	let pauser = Observable.of(trueAtThreeSeconds, falseAtFiveSeconds).merge()
	
	let pausedObservable = observable.pausable(pauser)
	
	pausedObservable
		.subscribe { print($0) }
	
	playgroundShouldContinueIndefinitely()
}

//: [Next](@next)
