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
 ## mapTo(KeyPath)

 The `mapTo` operator takes a sequence of elements and returns a sequence where each element is mapped to its value at the given key path
 */
example("replace any input with the value at key path") {
    struct Person {
        let name: String
    }

    let people: [Person] = [
        Person(name: "Bart"),
        Person(name: "Lisa"),
        Person(name: "Maggie")
    ]

    Observable.from(people)
        .mapTo(\.name)
        .toArray()
        .subscribe(onNext: {result in
            // look types on the right panel ===>
            people
            result
            print("mapTo() transformed \(people) to \(result)")
        })
}


//: [Next](@next)
