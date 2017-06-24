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
## pausableBuffered

Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.

While paused, elements from the source are buffered, limited to a maximum number of element.

When resumed, all bufered elements are flushed as single events in a contiguous stream.
*/

example("pausableBuffered") {
	
	let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
	
	let trueAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in true }
	let falseAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in false }
	let pauser = Observable.of(trueAtThreeSeconds, falseAtFiveSeconds).merge()
	
	// unlimited buffering of values received while paused
	let pausedObservable = observable.pausableBuffered(pauser, limit: nil)
	
	pausedObservable
		.subscribe { print($0) }
	
	playgroundShouldContinueIndefinitely()
	
}
//: [Next](@next)
