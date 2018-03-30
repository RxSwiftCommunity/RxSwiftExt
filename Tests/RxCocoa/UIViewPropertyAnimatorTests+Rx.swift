//
//  UIViewPropertyAnimatorTests+Rx.swift
//  RxSwiftExt
//
//  Created by Thibault Wittemberg on 3/4/18.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxSwiftExt
import UIKit

class UIViewPropertyAnimatorTests: XCTestCase {

    let disposeBag = DisposeBag()

    func testAnimationCompleted() {

        let expectations = expectation(description: "Animation completed")

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
                view.transform = CGAffineTransform(translationX: 100, y: 100)
            }
            animator.rx.animate().subscribe(onCompleted: {
                XCTAssertEqual(100, view.frame.origin.x)
                XCTAssertEqual(100, view.frame.origin.y)
                expectations.fulfill()
            }).disposed(by: self.disposeBag)
        } else {
            // Fallback on earlier versions
            expectations.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
