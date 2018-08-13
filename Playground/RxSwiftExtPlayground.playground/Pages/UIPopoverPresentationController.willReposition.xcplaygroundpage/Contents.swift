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
 ## willReposition
 
 The `willReposition` binder provides a reactive way to bind to `UIPopoverPresentationControllerDelegate.willReposition`.
 
 Please open the Assistant Editor (⌘⌥⏎) to see the Interactive Live View example.
 */

final class RootViewController: UIViewController {
    let leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(.red, for: .highlighted)
        button.setTitle("present popover", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(.red, for: .highlighted)
        button.setTitle("present popover and reposition", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textField: UITextField = {
        let filed = UITextField()
        filed.borderStyle = .roundedRect
        filed.placeholder = "don't touch me"
        filed.translatesAutoresizingMaskIntoConstraints = false
        return filed
    }()
    
    private var disposableBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray

        view.addSubview(leftView)
        view.addSubview(rightView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(textField)
        
        leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        leftView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        leftView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50).isActive = true
        leftView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        rightView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 50).isActive = true
        rightView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        leftButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
        leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        rightButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        rightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        leftButton.addTarget(self, action: #selector(presentPopover), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(presentPopoverReposition(_:)), for: .touchUpInside)
    }
    
    @objc private func presentPopover() {
        let popoverController = UIViewController()
        popoverController.view.backgroundColor = .cyan
        popoverController.modalPresentationStyle = .popover
        popoverController.popoverPresentationController?.sourceView = self.leftView
        popoverController.popoverPresentationController?.sourceRect = self.leftView.bounds
        
        disposableBag = DisposeBag()
        
        popoverController.popoverPresentationController!.rx.didDismiss
            .subscribe(onNext: { print("\(#function) - didDismiss") })
            .disposed(by: disposableBag)
        
        self.present(popoverController, animated: true)
    }
    
    @objc private func presentPopoverReposition(_ sender: UIButton) {
        let popoverController = UIViewController()
        popoverController.view.backgroundColor = .yellow
        popoverController.modalPresentationStyle = .popover
        popoverController.popoverPresentationController!.sourceView = sender
        popoverController.popoverPresentationController!.sourceRect = sender.bounds
        
        disposableBag = DisposeBag()
        
        popoverController.popoverPresentationController!.rx.willReposition
            .subscribe(onNext: { args in
                args.inView.pointee = self.rightView
                args.toRect.pointee = self.rightView.bounds
                
                print("\(#function) - willReposition")
            })
            .disposed(by: disposableBag)
        
        popoverController.popoverPresentationController!.rx.didDismiss
            .subscribe(onNext: {
                // hides the keyboard to show the buttons
                self.textField.resignFirstResponder()
            })
            .disposed(by: disposableBag)

        self.present(popoverController, animated: true) {
            // makes the popover to be resized to make room for the keyboard
            self.textField.becomeFirstResponder()
        }
    }
}

let rootViewController = RootViewController()
rootViewController.preferredContentSize = CGSize(width: 768 , height: 1024)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = rootViewController
//: [Next](@next)
