//
//  unwrap+SharedSequence.swift
//  RxSwiftExt
//
//  Created by Hugo Saynac on 05/10/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxCocoa

extension SharedSequence {

    /**
     Takes a SharedSequence of optional elements and returns a SharedSequence of non-optional elements, filtering out any nil values.

     - returns: A SharedSequence of non-optional elements
     */

    public func unwrap<T>() -> SharedSequence<S, T> where E == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
