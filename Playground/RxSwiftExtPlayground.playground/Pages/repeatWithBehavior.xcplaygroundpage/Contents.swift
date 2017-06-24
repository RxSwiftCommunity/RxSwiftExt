/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwiftExt

private enum SampleErrors : Error {
    case fatalError
}

let completingObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onCompleted()
    return Disposables.create()
}

let erroringObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onError(SampleErrors.fatalError)
    return Disposables.create()
}

let delayScheduler = SerialDispatchQueueScheduler(qos: .utility)

example("Immediate repeat") {
    // repeat immediately after completion
    _ = completingObservable.repeatWithBehavior(.immediate(maxCount: 2))
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
    })
}



example("Immediate repeat with custom predicate") {
    // here we provide a custom predicate that will determines whether we should resubscribe when the sequence is complete
    _ = completingObservable.repeatWithBehavior(.immediate(maxCount: 2), scheduler: delayScheduler) {
            return true
        }
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
    })
}

example("Delayed repeat") {
    // once complete, the observable will be resubscribed to after 1.0 second delay
    _ = completingObservable.repeatWithBehavior(.delayed(maxCount: 2, time: 1.0), scheduler: delayScheduler)
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
    })
}

// sleep in order to wait until previous example finishes
Thread.sleep(forTimeInterval: 2.5)

example("Exponential delay") {
    // when the sequence completes initial delay will be 1 second,
    // every next delay will be doubled
    // delay formula is: initial * pow(1 + multiplier, Double(currentAttempt - 1)), so multiplier 1.0 means, delay will doubled
    _ = completingObservable.repeatWithBehavior(.exponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.2), scheduler: delayScheduler)
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
    })
}

// sleep in order to wait until previous example finishes
Thread.sleep(forTimeInterval: 4.0)

example("Delay with calculator") {
    // custom delay calculator
    // will be invoked to calculate delay for particular repeat
    // will be invoked in the beginning of repeat
    let customCalculator: (UInt) -> Double = { attempt in
        switch attempt {
        case 1: return 0.5
        case 2: return 1.5
        default: return 2.0
        }
    }
    _ = completingObservable.repeatWithBehavior(.customTimerDelayed(maxCount: 3, delayCalculator: customCalculator), scheduler: delayScheduler)
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
    })
}

// sleep in order to wait until previous example finishes
Thread.sleep(forTimeInterval: 4.0)

example("Observable with error") {
    _ = erroringObservable.repeatWithBehavior(.immediate(maxCount: 2))
		.subscribe(onNext: { event in
            print("Receive event: \(event)")
		}, onError: { error in
			print("Repetition interrupted with error: \(error)")
		})
}

playgroundShouldContinueIndefinitely()

//: [Next](@next)
