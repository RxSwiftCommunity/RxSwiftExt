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

example("mapMany") {
    let numbers = Observable.of(1...10)
    let strings = Observable.of(["RxSwift", "is" ,"awesome", "along", "with", "RxSwiftCommunity"])

    // Map many using a model initializer
    numbers.mapMany(SomeModel.init)
        .subscribe(onNext: { result in
            print(result)
        })

    // Map many with a transformation closure
    numbers.mapMany { $0 * $0 }
        .subscribe(onNext: { result in
            print(result)
        })

    strings.mapMany { $0.lowercased() }
        .subscribe(onNext: { result in
            print(result)
        })

    struct SomeModel: CustomStringConvertible {
        let number: Int
        var description: String { return "#\(number)" }

        init(_ number: Int) {
            self.number = number
        }
    }
}

//: [Next](@next)
