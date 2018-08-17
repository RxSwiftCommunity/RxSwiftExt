//
//  UIScrollView+reachedBottom.swift
//  RxSwiftExt
//
//  Created by Anton Nazarov on 09/05/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { [base] contentOffset in
            let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
            let y = contentOffset.y + base.contentInset.top
            let threshold = max(offset, base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}
