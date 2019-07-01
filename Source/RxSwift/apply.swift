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

extension PrimitiveSequenceType {
    /// Apply a transformation function to the primitive sequence.
    public func apply<Result>(_ transform: (PrimitiveSequence<Trait, Element>) -> PrimitiveSequence<Trait, Result>)
        -> PrimitiveSequence<Trait, Result> {
        return transform(self.primitiveSequence)
    }
}
