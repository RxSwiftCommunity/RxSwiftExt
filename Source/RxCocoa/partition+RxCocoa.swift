//
//  partition+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Shai Mishali on 24/11/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift
import RxCocoa

public extension SharedSequence {
    /**
     Partition a stream into two separate streams of elements that match, and don't match, the provided predicate.

     - parameter predicate: A predicate used to filter matching and non-matching elements.

     - returns: A tuple of two streams of elements that match, and don't match, the provided predicate.
     */
    func partition(_ predicate: @escaping (E) -> Bool) -> (matches: SharedSequence<S, E>,
                                                           nonMatches: SharedSequence<S, E>) {
        let hits = self.filter(predicate)
        let misses = self.filter { !predicate($0) }

        return (hits, misses)
    }
}
