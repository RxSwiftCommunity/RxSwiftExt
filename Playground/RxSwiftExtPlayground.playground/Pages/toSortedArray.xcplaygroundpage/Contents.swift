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
 ## toSortedArray
 
 The `toSortedArray` operator transforms an observable of comparables into an observable of ordered arrays.
 */

example("Ensure that only a sorted array is emitted") {
    let sequenceStream = Observable.of(1...12)
    let array = Observable.of([10, 9, 12, 8, 4, 1, 1, 8, 14])

    // Ascending order
    array.toSortedArray()
        .subscribe(onNext: { result in
            print(result)
        })
    
    array.toSortedArray(<)
        .subscribe(onNext: { result in
            print(result)
        })
    
    // Descending order
    sequenceStream.toSortedArray(>)
        .subscribe(onNext: { result in
            print(result)
        })

    array.toSortedArray(>)
        .subscribe(onNext: { result in
            print(result)
        })
}

//: [Next](@next)
