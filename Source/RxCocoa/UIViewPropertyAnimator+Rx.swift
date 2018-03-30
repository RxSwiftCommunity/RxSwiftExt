//
//  UIViewPropertyAnimator+Rx.swift
//  RxSwiftExt
//
//  Created by Wittemberg, Thibault on 29/03/18.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

@available(iOSApplicationExtension 10.0, *)
extension Reactive where Base == UIViewPropertyAnimator {

    /// Completable that when subscribed to, starts the animation after a delay
    /// and completes once the animation is ended
    ///
    /// - Parameter delay: the delay to apply to the animation start
    /// - Returns: the Completable that will send .completed once the animation is ended
    public func animate(afterDelay delay: Double = 0) -> Completable {

        return Completable.create { [base] completable in

            base.addCompletion({ (position) in
                guard position == .end else { return }
                completable(.completed)
            })

            base.startAnimation(afterDelay: delay)

            return Disposables.create {
                base.stopAnimation(true)
            }
        }
    }
}
