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
 ## enumerated

 The `enumerated` operator converts an Observable into another Observable that also emits the index count of the emission.
 */

example("Ensure that only an enumerated element is emitted") {
    let ints = Observable.of(10, 9, 12, 8, 4, 1, 1, 8, 14)
    let chars = Observable.of("a", "b", "c", "d", "e", "f")

    ints.enumerated()
        .subscribe(onNext: { result in
            print(result)
        })

    print("-----------")
    
    chars.enumerated()
        .subscribe(onNext: { result in
            print(result)
    })
}

//: [Next](@next)
