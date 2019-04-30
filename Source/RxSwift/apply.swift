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
    public func apply<Result>(_ transform: (Observable<Element>) -> Observable<Result>) -> Observable<Result> {
        return transform(self.asObservable())
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    /// Apply a transformation function to the Single.
    public func apply<T>(_ transform: (Single<Element>) -> Single<T>) -> Single<T> {
        return transform(self.primitiveSequence)
    }
}
