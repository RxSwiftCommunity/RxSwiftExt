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

struct SomeModel: CustomStringConvertible {
    let number: Int
    var description: String { return "#\(number)" }

    init(_ number: Int) {
        self.number = number
    }
}

example("mapMany") {
    let ints = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let intsStream = Observable.just(ints)

    let strings = ["Make, sure, Carthage, RxSwiftExtPlayground"]
    let stringsStream = Observable.just(strings)

    intsStream.mapMany { $0 * $0 }
        .subscribe(onNext: { result in
            print(result)
        })

    intsStream.mapMany(SomeModel.init)
        .subscribe(onNext: { result in
            print(result)
        })


    stringsStream.mapMany { $0.lowercased() }
        .subscribe(onNext: { result in
            print(result)
        })
}

//: [Next](@next)
