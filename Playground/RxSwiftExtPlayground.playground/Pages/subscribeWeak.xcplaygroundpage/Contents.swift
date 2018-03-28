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

enum SampleError: Error {
    case fatalError
}

class Foo {
    let obs1 = Observable.of(3, 4, 6, 7)
    let obs2 = Observable<String>.create { observer in
        observer.onNext("First")
        observer.onError(SampleError.fatalError)
        observer.onNext("Second")
        observer.onCompleted()
        return Disposables.create()
    }
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    deinit { print("deinit") }
    
    func display(_ value: Any) {
        print(value)
    }
    
    func work1() {
        obs1.subscribe(weak: self) { strongSelf, event in
            strongSelf.display(event)
            }.disposed(by: disposeBag)
    }
    
    func work2() {
        obs2.subscribe(weak: self, onNext: { (strongSelf, value) in
            strongSelf.display(value)
        }, onError: { (strongSelf, error) in
            strongSelf.display(error)
        })
    }
}

example("subscribeWeak") {
    Foo().work1()
    Foo().work2()
}

//: [Next](@next)
