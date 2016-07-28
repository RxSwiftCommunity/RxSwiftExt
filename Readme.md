[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxSwiftExt.svg?branch=master)](https://travis-ci.org/RxSwiftCommunity/RxSwiftExt) ![pod](https://img.shields.io/cocoapods/v/RxSwiftExt.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxSwiftExt
===========

If you're using [RxSwift](https://github.com/ReactiveX/RxSwift), you may have encountered situations where the built-in operators do not bring the exact functionality you want. The RxSwift core is being intentionally kept as compact as possible to avoid bloat. This repository's purpose is to provide additional convenience operators.

Installation
===========

#### CocoaPods

```
use_frameworks!
pod "RxSwiftExt"
```

#### Carthage

Add this to your `Cartfile`

```
github "RxSwiftCommunity/RxSwiftExt"
```


Operators
===========

RxSwiftExt is all about adding operators to [RxSwift](https://github.com/ReactiveX/RxSwift)! Currently available operators:

* [unwrap](#unwrap)
* [ignore](#ignore)
* [ignoreWhen](#ignorewhen)
* [Observable.once](#once)
* [distinct](#distinct)
* [mapTo](#mapto)
* [not](#not)
* [Observable.cascade](#cascade)
* [retry](#retry)

##### unwrap

Unwrap optionals and filter out nil values.

```swift
  Observable.of(1,2,nil,Int?(4))
    .unwrap()
    .subscribe { print($0) }
```
```
Next(1)
Next(2)
Next(4)
```

##### ignore

Ignore specific elements.

```swift
  Observable<String>
    .of("One","Two","Three")
    .ignore("Two")
    .subscribe { print($0) }
```
```
Next(One)
Next(Three)
Completed  
```

##### ignoreWhen

Ignore elements according to closure.

```swift
  Observable<Int>
    .of(1,2,3,4,5,6)
    .ignoreWhen { $0 > 2 && $0 < 6 }
    .subscribe { print($0) }
```
```
Next(1)
Next(2)
Next(6)
Completed
```

##### once

Send a next element exactly once to the first subscriber that takes it. Further subscribers get an empty sequence.

```swift
  let obs = Observable.once("Hello world")
  print("First")
  obs.subscribe { print($0) }
  print("Second")
  obs.subscribe { print($0) }
```
```
First
Next(Hello world)
Completed
Second
Completed
```

##### distinct

Pass elements through only if they were never seen before in the sequence.

```swift
    Observable.of("a","b","a","c","b","a","d")
    .distinct()
    .subscribe { print($0) }
```
```
Next(a)
Next(b)
Next(c)
Next(d)
Completed
```

##### mapTo

Replace every element with the provided value.

```swift
Observable.of(1,2,3)
    .mapTo("Nope.")
    .subscribe { print($0) }
```
```
Next(Nope.)
Next(Nope.)
Next(Nope.)
Completed
```

##### not

Negate booleans.

```swift
Observable.just(false)
    .not()
    .subscribe { print($0) }
```
```
Next(true)
Completed
```

##### cascade

Sequentially cascade through a list of observable, dropping previous subscriptions as soon as an observable further down the list starts emitting elements.

```swift
let a = PublishSubject<String>()
let b = PublishSubject<String>()
let c = PublishSubject<String>()
Observable.cascade([a,b,c])
    .subscribe { print($0) }
a.onNext("a:1")
a.onNext("a:2")
b.onNext("b:1")
a.onNext("a:3")
c.onNext("c:1")
a.onNext("a:4")
b.onNext("b:4")
c.onNext("c:2")
```

```
Next(a:1)
Next(a:2)
Next(b:1)
Next(c:1)
Next(c:2)
```

##### retry

Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated. 
There are four behaviors:

```swift
public enum RepeatBehavior {
	// Specifies number or attempts to observe sequence. Retry will be performed without delay
	case Immediate (maxAttemptCount: UInt)
	// Specifies number or attempts to observe sequence.
	// Retry will be performed after specified delay
	case Delayed (maxAttemptCount: UInt, time: Double)
	// Specifies number or attempts to observe sequence.
	// Retry will be performed after specified delay.
	// First retry will be delayed by initial time, each next delay will be incremented by multiplier
	case ExponentialDelayed (maxAttemptCount: UInt, initial: Double, multiplier: Double)
	/// Specifies number or attempts to observe sequence.
	/// Provides custom closure to calculate delay
	case CustomTimerDelayed (maxAttemptCount: UInt, delayCalculator:(UInt -> Double))
}
```

For all cases maxAttemptCount = 1 means only one attempt and retry will not be performed if error occurred, maxAttemptCount = 0 means same as maxAttemptCount = 1.

ExponentialDelayed case uses this formula to calculate delay: `initial * pow(1 + multiplier, Double(currentAttempt - 1))`. So, multiplier 1.0 means delay will be incremented by 100%, multiplier 0.3 means delay will be incremented by 30%.

CustomTimerDelayed case invokes delayCalculator before actual attemp started and calculated delay will be used if error occurred. 

```swift
let sample = /* Any observable */
let delayScheduler = /* Any scheduler, that will be used for delay */
// immediate retry 
_ = sample.retry(.Immediate(maxAttemptCount: 3))
		.doOnError { error in
			print("Receive error \(error)")
		}
		.subscribeNext { event in
			print("Receive event: \(event)")
	}
// retry with custom calculator
let customCalculator: (UInt -> Double) = { attempt in
	switch attempt {
	case 1: return 0.5
	case 2: return 1.5
	default: return 2.0
	}
}
_ = sample.retry(.CustomTimerDelayed(maxAttemptCount: 3, delayCalculator: customCalculator), scheduler: delayScheduler)
	.doOnError { error in
		print("Receive error: \(error)")
	}
	.subscribeNext { event in
		print("1Receive event: \(event)")
}
```

More examples available in Playground.

## License

This library belongs to _RxSwiftCommunity_.

RxSwiftExt is available under the MIT license. See the LICENSE file for more info.
