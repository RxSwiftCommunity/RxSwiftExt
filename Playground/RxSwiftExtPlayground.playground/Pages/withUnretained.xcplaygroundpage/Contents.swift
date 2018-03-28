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

class Displayer {
    init() { }
    
    deinit {
        print("deinit")
    }
    
    func display(_ value: Any) {
        print(value)
    }
}

example("withUnretained") {
    let publishSubject = PublishSubject<Int>()
    var displayer: Displayer? = Displayer()
    
    if let displayer = displayer {
        _ = publishSubject
            .withUnretained(displayer) // -> Observable<(Displayer, Int)>
            .subscribe(onNext: { displayer, i in
                displayer.display(i)
            })
    }
    
    publishSubject.onNext(1)
    publishSubject.onNext(2)
    publishSubject.onNext(3)
    publishSubject.onNext(5)
    publishSubject.onNext(8)
    displayer = nil // the object referenced by `displayer` gets deallocated
    publishSubject.onNext(13)
    publishSubject.onNext(21)
    publishSubject.onCompleted()
}

//: [Next](@next)

