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
## nonPollingBuffer

 Projects each element of an observable sequence into a buffer that's sent out when a given amount of time has elapsed since the first event after the last flush.
 
 This is similar to the standard buffer except that events are not produced as the result of a polling timer.
*/

example("nonPollingBuffer") {
	
    Observable
        .merge([
            Observable.just(1).delay(0.00, scheduler: MainScheduler.instance),
            Observable.just(2).delay(0.25, scheduler: MainScheduler.instance),
            Observable.just(3).delay(0.75, scheduler: MainScheduler.instance),
            Observable.just(4).delay(1.00, scheduler: MainScheduler.instance)
        ])
        .nonPollingBuffer(
            timeSpan: 0.5,
            capacity: 1000,
            scheduler: MainScheduler.instance
        )
		.subscribe { print($0) }
	
	playgroundShouldContinueIndefinitely()
	
}
//: [Next](@next)
