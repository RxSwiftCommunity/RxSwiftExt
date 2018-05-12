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
 ## merge(with:)
 Merges elements from observable sequences into a single observable sequence.

 */
example("merge(with:)") {
    let oddNumbers = [1, 3, 5, 7, 9]
    let evenNumbers = [2, 4, 6, 8, 10]
    let otherNumbers = [1, 5 ,6, 2]

    let disposeBag = DisposeBag()
    let oddStream = Observable.from(oddNumbers)
    let evenStream = Observable.from(evenNumbers)
    let otherStream = Observable.from(otherNumbers)

    oddStream.merge(with: evenStream, otherStream)
        .subscribe(onNext: { result in
            print(result)
        })
        .disposed(by: disposeBag)
}

//: [Next](@next)
