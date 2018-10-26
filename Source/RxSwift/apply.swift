//
//  apply.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 2/22/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    /// Apply a transformation function to the Observable.
    public func apply<T>(_ transform: (Observable<Self.E>) -> Observable<T>) -> Observable<T> {
        return transform(self.asObservable())
    }
}

extension PrimitiveSequenceType where TraitType == SingleTrait {
    /// Apply a transformation function to the Single.
    public func apply<T>(_ transform: (Single<Self.ElementType>) -> Single<T>) -> Single<T> {
        return transform(self.primitiveSequence)
    }
}
