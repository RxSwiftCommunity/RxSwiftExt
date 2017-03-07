//
//  not+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/7/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import RxCocoa

extension SharedSequenceConvertibleType where E == Bool {
    /// Boolean not operator.
    public func not() -> SharedSequence<SharingStrategy, Bool> {
        return map(!)
    }
}
