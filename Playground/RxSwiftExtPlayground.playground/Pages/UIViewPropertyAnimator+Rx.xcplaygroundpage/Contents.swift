/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:

 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxCocoa
import RxSwiftExt
import PlaygroundSupport
import UIKit

/*:
 ## animate

 The `animate` operator provides a Completable that triggers the animation upon subscription and completes when the animation ends.

 Please open the Assistant Editor (⌘⌥⏎) to see the Interactive Live View example.
 */

class AnimateViewController: UIViewController {

    let disposeBag = DisposeBag()

    lazy var box1: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = .red
        return view
    }()

    lazy var box2: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 220, width: 100, height: 100))
        view.backgroundColor = .green
        return view
    }()

    lazy var box3: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 340, width: 100, height: 100))
        view.backgroundColor = .blue
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 200, height: 50))
        button.setTitle("Play animation", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2

        return button
    }()

    lazy var animator1 = {
        UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { [unowned self] in
            self.box1.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }()

    lazy var animator2 = {
        UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [unowned self] in
            self.box2.transform = CGAffineTransform(translationX: 0, y: -100)
                                    .scaledBy(x: 1.2, y: 1.2)
        }
    }()

    lazy var animator3 = {
        UIViewPropertyAnimator(duration: 0.15, curve: .easeInOut) { [unowned self] in
            self.box3.transform = CGAffineTransform(translationX: 0, y: -100)
                                    .rotated(by: CGFloat(M_PI))
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // construct the main view
        let views = [box1, box2, box3, button]
        view.backgroundColor = .white

        views.forEach {
            view.addSubview($0)
        }

        // Trigger chained animations after a button tap
        button.rx.tap
            .flatMap { [unowned self] in
                self.animator1.rx.animate()
                    .andThen(self.animator2.rx.animate(afterDelay: 0.2))
                    .andThen(self.animator3.rx.animate(afterDelay: 0.1))
                    .debug("animation sequence")
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = AnimateViewController()

//: [Next](@next)
