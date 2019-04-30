//
//  UIViewPropertyAnimator+Rx.swift
//  RxSwiftExt
//
//  Created by Wittemberg, Thibault on 29/03/18.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

#if os(iOS)
import Foundation
import UIKit
import RxSwift
import RxCocoa

@available(iOS 10.0, *)
public extension Reactive where Base: UIViewPropertyAnimator {
    /**
     Bindable extension for `fractionComplete` property.
     */
    var fractionComplete: Binder<CGFloat> {
        return Binder(base) { propertyAnimator, fractionComplete in
            propertyAnimator.fractionComplete = fractionComplete
        }
    }

    /// Provides a Completable that triggers the UIViewPropertyAnimator upon subscription
    /// and completes once the animation ends.
    ///
    /// - Parameter afterDelay: the delay to apply to the animation start
    ///
    /// - Returns: Completable
    func animate(afterDelay delay: TimeInterval = 0) -> Completable {
        return Completable.create { [base] completable in
            base.addCompletion { position in
                guard position == .end else { return }
                completable(.completed)
            }

            if delay != 0 {
                base.startAnimation(afterDelay: delay)
            } else {
                base.startAnimation()
            }

            return Disposables.create {
                base.stopAnimation(true)
            }
        }
    }
}
#endif
