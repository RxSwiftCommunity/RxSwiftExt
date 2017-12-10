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
 ## nwise

 The `nwise` operator groups elements emitted by an Observable into arrays, where each array consists of N consecutive items; similar to a sliding window.
 */

example("Grouping numbers into triples") {
    let input = [1, 2, 3, 4, 5, 6]

    print("Input:", input)
    print("Output:")

    Observable.from(input)
        .nwise(3)
        .subscribe(onNext: { result in
            print(result)
        })
}

/*:
 ## pairwise

 The `pairwise` operator is a special case of `nwise` with the size of 2, which emits the previous and current items in tuples instead of arrays.
 */

example("Grouping numbers into pairs") {
    let input = [1, 2, 3, 4, 5, 6]

    print("Input:", input)
    print("Output:")

    Observable.from(input)
        .pairwise()
        .subscribe(onNext: { result in
            print(result)
        })
}

//: [Next](@next)
