/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Build `RxSwiftExt` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

/*:
 # Introduction
 
 ## Additional operators for RxSwift
 
 The core RxSwift distribution provides an extensive set of operators to transform observables. RxSwiftExt aims at providing those less needed or convenience operators that do not necessarily fit in the core distribution, while being useful to many.
 We think that these additional operators will help beginners and intermediate Rx users alike by offering straightforward solutions to some of the common problems Rx users need to solve.
 
 ## About this playground
 
 Each page in the playground provides examples of use for each operator RxSwiftExt provides.
 
 ## Index:
 
 1. [unwrap()](unwrap) operator, takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any `nil` values
 1. [ignore(Any...)](ignore) operator, filters out any of the elements passed in parameters
 1. [Observable.once(Element)](once) contructor, creates a sequence that delivers an element *once* to the first subscriber then completes. The same sequence will complete immediately without delivering any element to all further subscribers.
 1. [mapTo(Any)](mapTo) operator, takes a sequence of elements and returns a sequence of the same constant provided as a parameter
 1. [not()](not) operator, applies a the boolean not (!) to a `Bool`
 1. [Observable.cascade([Observable])](cascade) contructor, takes a ordinary sequence (i.e. Array) of observables and cascades through them
 1. [distinct()](distinct) operator, suppress duplicate items emitted by an Observable
 1. [retryWithBehavior()](retryWithBehavior) operator, retry on error with various delay / predicate options
 1. [repeatWithBehavior()](retryWithBehavior) operator, repeat on completion with various delay / predicate options
 1. [catchErrorJustComplete()](catchErrorJustComplete) ignore any error and complete the sequence instead
 */

//: [Next >>](@next)
