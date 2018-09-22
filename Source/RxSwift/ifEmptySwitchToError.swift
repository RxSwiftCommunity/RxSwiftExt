//
//  ifEmptySwitchToError.swift
//  RxSwiftExt
//
//  Created by Thibault Wittemberg on 21/09/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

/// An extention to the Maybe trait that allows to trigger an Error in case of a "completed only" event (ie empty Maybe)
extension PrimitiveSequenceType where TraitType == MaybeTrait {

    /// If the Maybe triggers a Completed event without a Success first (ie empty Maybe), then it returns a Single that triggers the specified error
    ///
    /// - Parameter error: the Error the Single will trigger
    /// - Returns: the Single that will trigger the Error
    public func ifEmpty (switchToSingleWithError error: Error) -> Single<ElementType> {
        let errorSingle = Single<ElementType>.create { (observer) -> Disposable in
            observer(.error(error))
            return Disposables.create()
        }

        return self.ifEmpty(switchTo: errorSingle)
    }
}
