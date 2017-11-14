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

example("Combine observables using the .and(...) operator") {
    
    let bool = Observable.just(true)
    let bools = [Observable.just(true), Observable.just(true), Observable.just(true), Observable.just(false)]
    let output = bool.and(bools)

    output.subscribe(onNext: { value in
        print("output = \(value)")
    })
    
}

//: [Next](@next)
