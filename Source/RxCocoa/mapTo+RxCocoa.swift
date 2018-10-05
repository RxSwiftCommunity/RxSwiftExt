//
//  mapTo+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/7/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxCocoa

extension SharedSequenceConvertibleType {
    /**
     Returns an Unit containing as many elements as its input but all of them are the constant provided as a parameter

     - parameter value: A constant that each element of the input sequence is being replaced with
     - returns: An unit containing the values `value` provided as a parameter
     */
    public func mapTo<R>(_ value: R) -> SharedSequence<SharingStrategy, R> {
        return map { _ in value }
    }

    @available(*, deprecated, renamed: "mapTo(_:)")
    public func map<R>(to value: R) -> SharedSequence<SharingStrategy, R> {
        return map { _ in value }
    }
}
