//
//  UIViewPropertyAnimatorTests+Rx.swift
//  RxSwiftExt
//
//  Created by Thibault Wittemberg on 3/4/18.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

#if canImport(UIKit)
import XCTest
import RxSwift
import RxCocoa
import RxSwiftExt
import RxTest
import UIKit

@available(iOS 10.0, *)
class UIViewPropertyAnimatorTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
    }

    func testAnimationCompleted() {
        let expectations = expectation(description: "Animation completed")

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            view.transform = CGAffineTransform(translationX: 100, y: 100)
        }

        animator
            .rx.animate()
            .subscribe(onCompleted: {
                XCTAssertEqual(100, view.frame.origin.x)
                XCTAssertEqual(100, view.frame.origin.y)
                expectations.fulfill()
            })
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 1)
    }

    func testBindToFractionCompleted() {
        let animator = UIViewPropertyAnimator(
            duration: 0, curve: .linear, animations: { }
        )

        let subject = PublishSubject<CGFloat>()

        subject
            .bind(to: animator.rx.fractionComplete)
            .disposed(by: disposeBag)

        subject.onNext(0.3)
        XCTAssertEqual(animator.fractionComplete, 0.3)

        subject.onNext(0.5)
        XCTAssertEqual(animator.fractionComplete, 0.5)
    }
}
#endif
