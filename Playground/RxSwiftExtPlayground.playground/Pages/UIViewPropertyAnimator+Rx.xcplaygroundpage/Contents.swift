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

 The `animate` operators provide a Completable that when subscribed to starts the animation (after a delay or not) and completes once the animation is ended
 Please, active the assistant editor to see the preview
 */

class AnimateViewController : UIViewController {

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
        button.rx.tap.subscribe(onNext: { [unowned self] (_) in
            self.animate()
        }).disposed(by: self.disposeBag)
        return button
    }()

    lazy var animator1 = {
        UIViewPropertyAnimator(duration: 0.5, curve: .linear) { [unowned self] in
            self.box1.transform = CGAffineTransform(translationX: 0, y: -100)
        }
    }()

    lazy var animator2 = {
        UIViewPropertyAnimator(duration: 0.3, curve: .linear) { [unowned self] in
            self.box2.transform = CGAffineTransform(translationX: 0, y: -100).scaledBy(x: 1.2, y: 1.2)
        }
    }()

    lazy var animator3 = {
        UIViewPropertyAnimator(duration: 0.2, curve: .linear) { [unowned self] in
            self.box3.transform = CGAffineTransform(translationX: 0, y: -100).rotated(by: CGFloat(M_PI))
        }
    }()

    private func animate () {
        // trigger the animation chain
        self.animator1.rx.animate()
            .andThen(self.animator2.rx.animate(afterDelay: 0.2))
            .andThen(self.animator3.rx.animate(afterDelay: 0.1))
            .subscribe()
            .disposed(by: self.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // construct the main view
        self.view.backgroundColor = .white
        self.view.addSubview(self.box1)
        self.view.addSubview(self.box2)
        self.view.addSubview(self.box3)
        self.view.addSubview(self.button)
    }

}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = AnimateViewController()

//: [Next](@next)
