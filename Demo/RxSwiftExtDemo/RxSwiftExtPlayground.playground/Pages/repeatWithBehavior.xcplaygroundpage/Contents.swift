/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Build `RxSwiftExt` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwiftExt

private enum SampleErrors : ErrorType {
    case fatalError
}

let completedObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onCompleted()
    return NopDisposable.instance
}

let erroringObservable = Observable<String>.create { observer in
    observer.onNext("First")
    observer.onNext("Second")
    observer.onError(SampleErrors.fatalError)
    return NopDisposable.instance
}

let delayScheduler = SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Utility)

example("Immediate retry") {
    // after receiving error will immediate retry
    _ = completedObservable.retry(.Immediate(maxAttemptCount: 3))
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

example("Immediate retry with custom predicate") {
    // in this case we provide custom predicate, that will evaluate error and decide, should we retry or not
    _ = sampleObservable.retry(.Immediate(maxAttemptCount: 3), scheduler: delayScheduler) { error in
        // error checks here
        // in this example we simply say, that retry not allowed
        return false
        }
        .doOnError { error in
            print("Receive error \(error)")
        }
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

example("Delayed retry") {
    // after error, observable will be retried after 1.0 second delay
    _ = sampleObservable.retry(.Delayed(maxAttemptCount: 3, time: 1.0), scheduler: delayScheduler)
        .doOnError { error in
            print("Receive error: \(error)")
        }
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

// sleep in order to wait until previous example finishes
NSThread.sleepForTimeInterval(2.5)

example("Exponential delay") {
    // in case of an error initial delay will be 1 second,
    // every next delay will be doubled
    // delay formula is: initial * pow(1 + multiplier, Double(currentAttempt - 1)), so multiplier 1.0 means, delay will doubled
    _ = sampleObservable.retry(.ExponentialDelayed(maxAttemptCount: 3, initial: 1.0, multiplier: 1.0), scheduler: delayScheduler)
        .doOnError { error in
            print("Receive error: \(error)")
        }
        .subscribeNext { event in
            print("Receive event: \(event)")
    }
}

// sleep in order to wait until previous example finishes
NSThread.sleepForTimeInterval(4.0)

example("Delay with calculator") {
    // custom delay calculator
    // will be invoked to calculate delay for particular attempt
    // will be invoked in the beginning of attempt, not when error occurred
    let customCalculator: (UInt -> Double) = { attempt in
        switch attempt {
        case 1: return 0.5
        case 2: return 1.5
        default: return 2.0
        }
    }
    _ = sampleObservable.retry(.CustomTimerDelayed(maxAttemptCount: 3, delayCalculator: customCalculator), scheduler: delayScheduler)
        .doOnError { error in
            print("Receive error: \(error)")
        }
        .subscribeNext { event in
            print("1Receive event: \(event)")
    }
}

playgroundShouldContinueIndefinitely()

//: [Next](@next)
