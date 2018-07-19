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

playgroundShouldContinueIndefinitely()

/*:
 ## drive(_: Collection)

 The `drive(_: Collection)` operator drives a collection of observers.
 */

example("Drive a collection of observers") {

    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    let isEditableStream = Driver.of(true, false, false, true)

    textField1.rx.observe(Bool.self, "enabled").debug("textField1").subscribe()
    textField2.rx.observe(Bool.self, "enabled").debug("textField2").subscribe()
    textField3.rx.observe(Bool.self, "enabled").debug("textField3").subscribe()

    isEditableStream.drive([textField1.rx.isEnabled,
                            textField2.rx.isEnabled,
                            textField3.rx.isEnabled])

    isEditableStream.drive(textField1.rx.isEnabled,
                           textField2.rx.isEnabled,
                           textField3.rx.isEnabled)
}

//: [Next](@next)
