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

let sampleObservable = Observable<String>.create { observer in
	observer.onNext("First")
	observer.onNext("Second")
	observer.onError(SampleErrors.fatalError)
	observer.onCompleted()
	return Disposables.create()
}

let delayScheduler = SerialDispatchQueueScheduler(qos: .utility)

example("Immediate retry") {
	// after receiving error will immediate retry
	_ = sampleObservable.retry(.immediate(maxCount: 3))
		.subscribe(onNext: { event in
			print("Receive event: \(event)")
		}, onError: { error in
			print("Receive error \(error)")
		})
}

example("Immediate retry with custom predicate") {
	// in this case we provide custom predicate, that will evaluate error and decide, should we retry or not
	_ = sampleObservable.retry(.immediate(maxCount: 3), scheduler: delayScheduler) { error in
		// error checks here
		// in this example we simply say, that retry not allowed
		return false
		}
		.subscribe(onNext: { event in
			print("Receive event: \(event)")
		}, onError: { error in
			print("Receive error \(error)")
		})
}

example("Delayed retry") {
	// after error, observable will be retried after 1.0 second delay
	_ = sampleObservable.retry(.delayed(maxCount: 3, time: 1.0), scheduler: delayScheduler)
		.subscribe(onNext: { event in
			print("Receive event: \(event)")
		}, onError: { error in
			print("Receive error: \(error)")
		})
}

// sleep in order to wait until previous example finishes
Thread.sleep(forTimeInterval: 2.5)

example("Exponential delay") {
	// in case of an error initial delay will be 1 second,
	// every next delay will be doubled
	// delay formula is: initial * pow(1 + multiplier, Double(currentRepetition - 1)), so multiplier 1.0 means, delay will doubled
	_ = sampleObservable.retry(.exponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.0), scheduler: delayScheduler)
		.subscribe(onNext: { event in
			print("Receive event: \(event)")
		}, onError: { error in
			print("Receive error: \(error)")
		})
}

// sleep in order to wait until previous example finishes
Thread.sleep(forTimeInterval: 4.0)

example("Delay with calculator") {
	// custom delay calculator
	// will be invoked to calculate delay for particular repetition
	// will be invoked in the beginning of repetition, not when error occurred
	let customCalculator: (UInt) -> Double = { attempt in
		switch attempt {
		case 1: return 0.5
		case 2: return 1.5
		default: return 2.0
		}
	}
	_ = sampleObservable.retry(.customTimerDelayed(maxCount: 3, delayCalculator: customCalculator), scheduler: delayScheduler)
		.subscribe(onNext: { event in
			print("Receive event: \(event)")
		}, onError: { error in
			print("Receive error: \(error)")
		})
}

playgroundShouldContinueIndefinitely()

//: [Next](@next)
