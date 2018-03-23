/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import Foundation
import RxSwift
import RxSwiftExt

private class Tool {
    
    deinit {
        print("deinit")
    }
    
    func display(_ value: Any) {
        print(value)
    }
    
    func produce(_ value: Int) -> Observable<Int> {
        return Observable.of(value * 2, value * 3)
    }
}

example("weak") {
    let observable = Observable.of(2, 5, 7)
    
    observable.subscribe(weak: Tool()) { (strongTool, event) in
        strongTool.display(event)
    }
    
    var tool: Tool? = Tool()
    
    observable.flatMap(weak: tool!) { (strongTool, value) in
        strongTool.produce(value)
    }.subscribe(weak: tool!, onNext: { (strongTool, value) in
        strongTool.display(value)
    })
    
    tool = nil
}

//: [Next](@next)
