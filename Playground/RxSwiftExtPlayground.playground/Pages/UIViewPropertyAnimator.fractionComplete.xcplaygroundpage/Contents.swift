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
 ## fractionComplete
 
 The `fractionComplete` binder provides a reactive way to bind to `UIViewPropertyAnimator.fractionComplete`.
 
 Please open the Assistant Editor (⌘⌥⏎) to see the Interactive Live View example.
 */

class FractionCompleteViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var box: UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = .purple
        return view
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var animator: UIViewPropertyAnimator = {
        UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            let transform = CGAffineTransform(translationX: 100, y: 0)
                .concatenating(CGAffineTransform(rotationAngle: 360))
            self.box.transform = transform
        })
    }()
    
    lazy var fractionCompleteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // construct the main view
        view.backgroundColor = .white
        setupViewHierarchy()
        setupConstraints()
        
        slider.rx.value.map(CGFloat.init)
            .bind(to: animator.rx.fractionComplete)
            .disposed(by: disposeBag)
        
        slider.rx.value
            .map { value in
                String(format: "fractionComplete: %.2lf", value)
            }
            .bind(to: fractionCompleteLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupViewHierarchy() {
        [box, slider, fractionCompleteLabel]
            .forEach(view.addSubview)
    }
    
    private func setupConstraints() {
        
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        fractionCompleteLabel.topAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        fractionCompleteLabel.centerXAnchor.constraint(equalTo: slider.centerXAnchor).isActive = true
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = FractionCompleteViewController()

//: [Next](@next)
