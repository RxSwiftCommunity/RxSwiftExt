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
 ## sorted
 
 The `sorted` operator transforms an observable of comparables into an observable of ordered arrays.
 */

example("Ensure that only a sorted array is emitted") {
    let array1 = Observable.of([5, 4, 7, 8, 2, 6, 9, 0, 10])
    let array2 = Observable.of([10, 9, 12, 8, 4, 1, 1, 8, 14])
    let empty = Observable<Bool>.empty()
    
    array1.sorted()
        .subscribe(onNext: { result in
            print(result)
        })
    
    // Ascending order
    array2.sorted(<)
        .subscribe(onNext: { result in
            print(result)
        })
    
    // Descending order
    array2.sorted(>)
        .subscribe(onNext: { result in
            print(result)
        })
}

//: [Next](@next)
