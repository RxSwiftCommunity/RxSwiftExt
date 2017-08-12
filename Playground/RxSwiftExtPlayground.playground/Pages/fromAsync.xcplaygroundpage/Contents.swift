/*:
> # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
1. Build scheme `RxSwiftExt (playground)` scheme for a simulator target
1. Choose `View > Show Debug Area`
*/

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

/*:
## Observable.fromAsync()

This function takes as argument a function that takes up to 9 arbitrary arguments and a completionHandler
and returns a function with the same signature, minus the completionHandler, and returns an Observable with
the same Element type as the completionHandler
*/

func myService(arg1: String, arg2: Int, completionHandler:(String) -> Void) {
    Thread.sleep(forTimeInterval: 0.2)
    
    completionHandler("Result")
}

let observableService = Observable.fromAsync(myService(arg1:arg2:completionHandler:))

observableService("Foo", 0).subscribe(onNext: { (result) in
    print(result)
}).addDisposableTo(DisposeBag())

//: [Next](@next)
