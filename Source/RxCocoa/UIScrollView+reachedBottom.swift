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
     Shows if the the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom.
     - returns: Sequence that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> Observable<Void> {
        return contentOffset.filterMap { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold ? .map(()) : .ignore
        }
    }
}
