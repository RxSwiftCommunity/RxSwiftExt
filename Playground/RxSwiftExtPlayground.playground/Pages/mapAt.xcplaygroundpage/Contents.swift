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
 ## mapAt(KeyPath)

 The `mapAt` operator transforms a sequence of elements where each element is mapped to its value at the provided key path
 */
example("map input to the value at provided key path") {
    struct Person {
        let name: String
    }

    let people: [Person] = [
        Person(name: "Bart"),
        Person(name: "Lisa"),
        Person(name: "Maggie")
    ]

    Observable.from(people)
        .mapAt(\.name)
        .toArray()
        .subscribe(onNext: {result in
            // look types on the right panel ===>
            people
            result
            print("mapAt() transformed \(people) to \(result)")
        })
}


//: [Next](@next)
