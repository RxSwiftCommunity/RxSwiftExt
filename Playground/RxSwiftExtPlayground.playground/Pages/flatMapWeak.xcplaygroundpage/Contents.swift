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

class Foo {
    let obs1 = Observable.of(3, 4, 6, 7)
    let obs2 = { (value: Int) in Observable.of(value * 2, value * 3, value * 4) }
    
    let disposeBag = DisposeBag()
    
    init() { }
    
    deinit { print("deinit") }
    
    func work() {
        obs1.flatMap(weak: self) { (strongSelf, value) in
            return strongSelf.obs2(value)
            }.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
    }
}

example("flatMapWeak") {
    Foo().work()
}

//: [Next](@next)
