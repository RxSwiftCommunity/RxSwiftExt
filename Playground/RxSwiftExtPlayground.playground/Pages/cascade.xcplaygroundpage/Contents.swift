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
 ## cascade
 
 The `cascade` operator takes a ordinary sequence (i.e. Array) of observables and cascades through them: 
 - it first subscribes to all observables in the sequence
 - every time an observable emits an element, all previous observables in the sequence are unsubscribed from, and elements from this observables are sent through
 - when any of the currently subscribed-to observables errors, the resulting observable errors too
 */

example("cascade") {

    // produce an infinite sequence of numbers starting at 0
    let a = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .map { "a emitted \($0)" }
    
    // produce an infinite sequence of numbers after a 3 second delay
    let b = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .map { "b emitted \($0)" }
        .delaySubscription(3, scheduler: MainScheduler.instance)
    
    // produce an infinite sequence of numbers after a 6 second delay
    let c = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .map { "c emitted \($0)" }
        .delaySubscription(6, scheduler: MainScheduler.instance)
    
    // cascade subscribes to all three observables, but switches to the latest one in the
    // observables list, unsubscribing from previous ones. The resulting sequence will
    // first output values from `a' (as they are being emitted immediately) then switch to
    // `b' as soon as it starts emitting values (after 3 seconds) then switch to `c' as soon
    // as it starts emitting values (after 6 seconds), effectively cascading through the
    // given observables with no possible return to previous ones.
    Observable.cascade([a,b,c])
		.subscribe(onNext: {
            print("Cascade next: \($0)")
        })
    
    // watch the resulting sequence in the playground debug area!
    playgroundShouldContinueIndefinitely()
}

//: [Next](@next)
