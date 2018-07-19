/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)
import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

/*:
 ## bind(to: Collection)

 The `bind(to: Collection)` operator binds an observable to a collection of observers.
 */

example("Bind an observable to a collection of observers") {
    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    let isEditableStream = Observable.of(true, false, false, true)

    textField1.rx.observeWeakly(Bool.self, "enabled").debug("textField1").subscribe()
    textField2.rx.observeWeakly(Bool.self, "enabled").debug("textField2").subscribe()
    textField3.rx.observeWeakly(Bool.self, "enabled").debug("textField3").subscribe()

    isEditableStream.bind(to: [textField1.rx.isEnabled,
                               textField2.rx.isEnabled,
                               textField3.rx.isEnabled])

    isEditableStream.bind(to: textField1.rx.isEnabled,
                              textField2.rx.isEnabled,
                              textField3.rx.isEnabled)
}

//: [Next](@next)
