[![CircleCI](https://img.shields.io/circleci/project/github/RxSwiftCommunity/RxSwiftExt/master.svg)](https://circleci.com/gh/RxSwiftCommunity/RxSwiftExt/tree/master)
![pod](https://img.shields.io/cocoapods/v/RxSwiftExt.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

RxSwiftExt
===========

If you're using [RxSwift](https://github.com/ReactiveX/RxSwift), you may have encountered situations where the built-in operators do not bring the exact functionality you want. The RxSwift core is being intentionally kept as compact as possible to avoid bloat. This repository's purpose is to provide additional convenience operators and Reactive Extensions.

Installation
===========

This branch of RxSwiftExt targets Swift 4.x and RxSwift 4.0.0 or later.

* If you're looking for the Swift 3 version of RxSwiftExt, please use version `2.5.1` of the framework.
* If your project is running on Swift 2.x, please use version `1.2` of the framework.

#### CocoaPods

Using Swift 4:

```ruby
pod 'RxSwiftExt'
```

This will install both the `RxSwift` and `RxCocoa` extensions.
If you're interested in only installing the `RxSwift` extensions, without the `RxCocoa` extensions, simply use:

```ruby
pod 'RxSwiftExt/Core'
```

Using Swift 3:

```ruby
pod 'RxSwiftExt', '2.5.1'
```

If you use Swift 2.x:

```ruby
pod 'RxSwiftExt', '1.2'
```

#### Carthage

Add this to your `Cartfile`

```
github "RxSwiftCommunity/RxSwiftExt"
```

Operators
===========

RxSwiftExt is all about adding operators and Reactive Extensions to [RxSwift](https://github.com/ReactiveX/RxSwift)!

## Operators

These operators are much like the RxSwift & RxCocoa core operators, but provide additional useful abilities to your Rx arsenal.

* [unwrap](#unwrap)
* [ignore](#ignore)
* [ignoreWhen](#ignorewhen)
* [Observable.once](#once)
* [distinct](#distinct)
* [map](#map)
* [not](#not)
* [and](#and)
* [Observable.cascade](#cascade)
* [pairwise](#pairwise)
* [nwise](#nwise)
* [retry](#retry)
* [repeatWithBehavior](#repeatwithbehavior)
* [catchErrorJustComplete](#catcherrorjustcomplete)
* [pausable](#pausable)
* [pausableBuffered](#pausablebuffered)
* [apply](#apply)
* [filterMap](#filtermap)
* [Observable.fromAsync](#fromasync)
* [Observable.zip(with:)](#zipwith)
* [withUnretained](#withunretained)
* [count](#count)

There are two more available operators for `materialize()`'d sequences:

* [errors](#errors-elements)
* [elements](#errors-elements)

Read below for details about each operator.

## Reactive Extensions

RxSwift/RxCocoa Reactive Extensions are provided to enhance existing objects and classes from the Apple-ecosystem with Reactive abilities.

* [UIViewPropertyAnimator.animate](#uiviewpropertyanimatoranimate)

--------

Operator details
===========

#### unwrap

Unwrap optionals and filter out nil values.

```swift
  Observable.of(1,2,nil,Int?(4))
    .unwrap()
    .subscribe { print($0) }
```

```
next(1)
next(2)
next(4)
```

#### ignore

Ignore specific elements.

```swift
  Observable.from(["One","Two","Three"])
    .ignore("Two")
    .subscribe { print($0) }
```

```
next(One)
next(Three)
completed
```

#### ignoreWhen

Ignore elements according to closure.

```swift
  Observable<Int>
    .of(1,2,3,4,5,6)
    .ignoreWhen { $0 > 2 && $0 < 6 }
    .subscribe { print($0) }
```
```
next(1)
next(2)
next(6)
completed
```

#### once

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
next(Hello world)
completed
Second
completed
```

#### distinct

Pass elements through only if they were never seen before in the sequence.

```swift
Observable.of("a","b","a","c","b","a","d")
    .distinct()
    .subscribe { print($0) }
```
```
next(a)
next(b)
next(c)
next(d)
completed
```

#### mapTo

Replace every element with the provided value.

```swift
Observable.of(1,2,3)
    .mapTo("Nope.")
    .subscribe { print($0) }
```
```
next(Nope.)
next(Nope.)
next(Nope.)
completed
```

#### mapAt

Transform every element to the value at the provided key path.

```swift
struct Person {
    let name: String
}

Observable
    .of(
        Person(name: "Bart"),
        Person(name: "Lisa"),
        Person(name: "Maggie")
    )
    .mapAt(\.name)
    .subscribe { print($0) }
```
```
next(Bart)
next(Lisa)
next(Maggie)
completed
```
#### not

Negate booleans.

```swift
Observable.just(false)
    .not()
    .subscribe { print($0) }
```

```
next(true)
completed
```

#### and

Verifies that every value emitted is `true`

```swift
Observable.of(true, true)
	.and()
	.subscribe { print($0) }

Observable.of(true, false)
	.and()
	.subscribe { print($0) }

Observable<Bool>.empty()
	.and()
	.subscribe { print($0) }
```

Returns a `Maybe<Bool>`:

```
success(true)
success(false)
completed
```

#### cascade

Sequentially cascade through a list of observables, dropping previous subscriptions as soon as an observable further down the list starts emitting elements.

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
next(a:1)
next(a:2)
next(b:1)
next(c:1)
next(c:2)
```

#### pairwise

Groups elements emitted by an Observable into arrays, where each array consists of the last 2 consecutive items; similar to a sliding window.

```swift
Observable.from([1, 2, 3, 4, 5, 6])
    .pairwise()
    .subscribe { print($0) }
```

```
next((1, 2))
next((2, 3))
next((3, 4))
next((4, 5))
next((5, 6))
completed
```

#### nwise

Groups elements emitted by an Observable into arrays, where each array consists of the last N consecutive items; similar to a sliding window.

```swift
Observable.from([1, 2, 3, 4, 5, 6])
    .nwise(3)
    .subscribe { print($0) }
```

```
next([1, 2, 3])
next([2, 3, 4])
next([3, 4, 5])
next([4, 5, 6])
completed
```

#### retry

Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated.
There are four behaviors with various predicate and delay options: `immediate`, `delayed`, `exponentialDelayed` and
`customTimerDelayed`.

```swift
// in case of an error initial delay will be 1 second,
// every next delay will be doubled
// delay formula is: initial * pow(1 + multiplier, Double(currentAttempt - 1)), so multiplier 1.0 means, delay will doubled
_ = sampleObservable.retry(.exponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.0), scheduler: delayScheduler)
    .subscribe(onNext: { event in
        print("Receive event: \(event)")
    }, onError: { error in
        print("Receive error: \(error)")
    })
```

```
Receive event: First
Receive event: Second
Receive event: First
Receive event: Second
Receive event: First
Receive event: Second
Receive error: fatalError
```

#### repeatWithBehavior

Repeats the source observable sequence using given behavior when it completes. This operator takes the same parameters as the [retry](#retry) operator.
There are four behaviors with various predicate and delay options: `immediate`, `delayed`, `exponentialDelayed` and `customTimerDelayed`.

```swift
// when the sequence completes initial delay will be 1 second,
// every next delay will be doubled
// delay formula is: initial * pow(1 + multiplier, Double(currentAttempt - 1)), so multiplier 1.0 means, delay will doubled
_ = completingObservable.repeatWithBehavior(.exponentialDelayed(maxCount: 3, initial: 1.0, multiplier: 1.2), scheduler: delayScheduler)
    .subscribe(onNext: { event in
        print("Receive event: \(event)")
})
```

```
Receive event: First
Receive event: Second
Receive event: First
Receive event: Second
Receive event: First
Receive event: Second
```

#### catchErrorJustComplete

Completes a sequence when an error occurs, dismissing the error condition

```swift
let _ = sampleObservable
    .do(onError: { print("Source observable emitted error \($0), ignoring it") })
    .catchErrorJustComplete()
    .subscribe {
        print ("\($0)")
}
```

```
next(First)
next(Second)
Source observable emitted error fatalError, ignoring it
completed
```

#### pausable

Pauses the elements of the source observable sequence unless the latest element from the second observable sequence is `true`.

```swift
let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

let trueAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in true }
let falseAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in false }
let pauser = Observable.of(trueAtThreeSeconds, falseAtFiveSeconds).merge()

let pausedObservable = observable.pausable(pauser)

let _ = pausedObservable
    .subscribe { print($0) }
```

```
next(2)
next(3)
```

More examples are available in the project's Playground.

#### pausableBuffered

Pauses the elements of the source observable sequence unless the latest element from the second observable sequence is `true`. Elements emitted by the source observable are buffered (with a configurable limit) and "flushed" (re-emitted) when the observable resumes.

Examples are available in the project's Playground.

#### apply

Apply provides a unified mechanism for applying transformations on Observable
sequences, without having to extend ObservableType or repeating your
transformations. For additional rationale for this see
[discussion on github](https://github.com/RxSwiftCommunity/RxSwiftExt/issues/73)

```swift
// An ordinary function that applies some operators to its argument, and returns the resulting Observable
func requestPolicy(_ request: Observable<Void>) -> Observable<Response> {
    return request.retry(maxAttempts)
        .do(onNext: sideEffect)
        .map { Response.success }
        .catchError { error in Observable.just(parseRequestError(error: error)) }

// We can apply the function in the apply operator, which preserves the chaining style of invoking Rx operators
let resilientRequest = request.apply(requestPolicy)
```

#### filterMap

A common pattern in Rx is to filter out some values, then map the remaining ones to something else. `filterMap` allows you to do this in one step:

```swift
// keep only odd numbers and double them
Observable.of(1,2,3,4,5,6)
	.filterMap { number in
		(number % 2 == 0) ? .ignore : .map(number * 2)
	}
```

The sequence above keeps even numbers 2, 4, 6 and produces the sequence 4, 8, 12.

#### errors, elements

These operators only apply to observable serquences that have been materialized with the `materialize()` operator (from RxSwift core). `errors` returns a sequence of filtered error events, ommitting elements. `elements` returns a sequence of filtered element events, ommitting errors.

```swift
let imageResult = _chooseImageButtonPressed.asObservable()
    .flatMap { imageReceiver.image.materialize() }
    .share()

let image = imageResult
    .elements()
    .asDriver(onErrorDriveWith: .never())

let errorMessage = imageResult
    .errors()
    .map(mapErrorMessages)
    .unwrap()
    .asDriver(onErrorDriveWith: .never())
```

#### fromAsync

Turns simple asynchronous completion handlers into observable sequences. Suitable for use with existing asynchronous services which call a completion handler with only one parameter. Emits the result produced by the completion handler then completes.

```swift
func someAsynchronousService(arg1: String, arg2: Int, completionHandler:(String) -> Void) {
    // a service that asynchronously calls
	// the given completionHandler
}

let observableService = Observable
    .fromAsync(someAsynchronousService)

observableService("Foo", 0)
    .subscribe(onNext: { (result) in
        print(result)
    })
    .disposed(by: disposeBag)
```

#### zipWith

Convenience version of `Observable.zip(_:)`. Merges the specified observable sequences into one observable sequence by using the selector function whenever all
 of the observable sequences have produced an element at a corresponding index.

```swift
let first = Observable.from(numbers)
let second = Observable.from(strings)

first.zip(with: second) { i, s in
        s + String(i)
    }.subscribe(onNext: { (result) in
        print(result)
    })
```

```
next("a1")
next("b2")
next("c3")
```

#### ofType

The ofType operator filters the elements of an observable sequence, if that is an instance of the supplied type.

```swift
Observable.of(NSNumber(value: 1),
                  NSDecimalNumber(string: "2"),
                  NSNumber(value: 3),
                  NSNumber(value: 4),
                  NSDecimalNumber(string: "5"),
                  NSNumber(value: 6))
        .ofType(NSDecimalNumber.self)
        .subscribe { print($0) }
```
```
next(2)
next(5)
completed
```
This example emits 2, 5 (`NSDecimalNumber` Type).

#### withUnretained

The `withUnretained(_:resultSelector:)` operator provides an unretained, safe to use (i.e. not implicitly unwrapped), reference to an object along with the events emitted by the sequence.
In the case the provided object cannot be retained successfully, the seqeunce will complete.

```swift
class TestClass: CustomStringConvertible {
    var description: String { return "Test Class" }
}

Observable
    .of(1, 2, 3, 5, 8, 13, 18, 21, 23)
    .withUnretained(testClass)
    .do(onNext: { _, value in
        if value == 13 {
            // When testClass becomes nil, the next emission of the original
            // sequence will try to retain it and fail. As soon as it fails,
            // the sequence will complete.
            testClass = nil
        }
    })
    .subscribe()
```

```
next((Test Class, 1))
next((Test Class, 2))
next((Test Class, 3))
next((Test Class, 5))
next((Test Class, 8))
next((Test Class, 13))
completed
```

#### [count](http://reactivex.io/documentation/operators/count.html)

Emits the number of items emitted by an Observable once it terminates with no errors. If a predicate is given, only elements matching the predicate will be counted.

```swift
Observable.from([1, 2, 3, 4, 5, 6])
    .count { $0 % 2 == 0 }
    .subscribe()
```

```
next(3)
completed
```

Reactive Extensions details
===========

#### UIViewPropertyAnimator.animate

The `animate(afterDelay:)` operator provides a Completable that triggers the animation upon subscription and completes when the animation ends.

```swift
button.rx.tap
    .flatMap {
        animator1.rx.animate()
            .andThen(animator2.rx.animate(afterDelay: 0.15))
            .andThen(animator3.rx.animate(afterDelay: 0.1))
    }
```

#### UIViewPropertyAnimator.fractionComplete
The `fractionComplete` binder provides a reactive way to bind to `UIViewPropertyAnimator.fractionComplete`.
```swift
slider.rx.value.map(CGFloat.init)
    .bind(to: animator.rx.fractionComplete)
```
## License

This library belongs to _RxSwiftCommunity_.

RxSwiftExt is available under the MIT license. See the LICENSE file for more info.
