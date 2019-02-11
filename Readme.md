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

<ul>
<li>
<details>
<summary><strong>apply</strong></summary>

 The `apply` operator takes a transformation function `(Observable) -> Observable` and applies it to the stream. The purpose of this operator is to provide syntactic sugar for applying multiple operators to the stream, while preserving the chaining operator structure of Rx.<br />

```swift
    return input
        .map { $0 + 1 }
        .map { "The next number is \($0)" }
}

let numbers1 = Observable.from([1, 2, 3])
let numbers2 = Observable.from([100, 101, 102])
let number3 = Single.just(1)
let number4 = Single.just(100)

print("apply() calls the transform function on the Observable sequence: ")

let transformed1 = numbers1.apply(addOne)
let transformed2 = numbers2.apply(addOne)
let transformed3 = number3.apply(addOne)
let transformed4 = number4.apply(addOne)

transformed1.subscribe(onNext: { result in
    print(result)
})

transformed2.subscribe(onNext: { result in
    print(result)
})

transformed3.subscribe(onSuccess: { result in
    print(result)
})

transformed4.subscribe(onSuccess: { result in
    print(result)
})
```
</details>
</li>

<li>
<details>
<summary><strong>bufferWithTrigger</strong></summary>
 Collects the elements of the source observable, and emits them as an array when the trigger emits.<br />

```swift
let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

let signalAtThreeSeconds = Observable<Int>.timer(3, scheduler: MainScheduler.instance).map { _ in () }
let signalAtFiveSeconds = Observable<Int>.timer(5, scheduler: MainScheduler.instance).map { _ in () }
let trigger = Observable.of(signalAtThreeSeconds, signalAtFiveSeconds).merge()

observable.bufferWithTrigger(trigger).debug("buffer").subscribe()
```
</details>
</li>

<li>
<details>
<summary><strong>count</strong></summary>
 Count the number of items emitted by an Observable<br /> - seealso: [count operator on reactivex.io](http://reactivex.io/documentation/operators/count.html)
 - parameter predicate: predicate determines what elements to be counted.

 - returns: An Observable sequence containing a value that represents how many elements in the specified observable sequence satisfy a condition if provided, else the count of items.



```swift
        print ($0)
    })
```
</details>
</li>

<li>
<details>
<summary><strong>not</strong></summary>
 The `not` operator applies a the boolean not (!) to a `Bool`<br />

```swift

_ = Observable.just(false)
    .not()
	.subscribe(onNext: { result in
        assert(result)
		print("Success! result = \(result)")
    })
```
</details>
</li>

<li>
<details>
<summary><strong>nwise</strong></summary>
 The `nwise` operator groups elements emitted by an Observable into arrays, where each array consists of N consecutive items; similar to a sliding window.<br />

```swift
let input = [1, 2, 3, 4, 5, 6]

print("Input:", input)
print("Output:")

Observable.from(input)
    .pairwise()
    .subscribe(onNext: { result in
        print(result)
    })
```
</details>
</li>
</ul>