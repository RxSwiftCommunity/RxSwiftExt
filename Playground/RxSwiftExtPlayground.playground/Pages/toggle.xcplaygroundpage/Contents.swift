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
 ## toggle
 
 The `toggle` starts with an initial boolean value, and then toggles it at each .next event
 */

example("Grouping numbers into triples") {
    let input = [1, 2, 3, 4]
    
    print("Input:", input)
    print("Output:")
    
    Observable.from(input)
        .toggle(initial: false)
        .subscribe(onNext: { result in
            print(result)
        })
}

//: [Next](@next)

