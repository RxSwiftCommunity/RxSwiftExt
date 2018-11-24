//
//  partition.swift
//  RxSwiftExt
//
//  Created by Shai Mishali on 24/11/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift

public extension ObservableType {
    /**
     Partition a stream into two separate streams of elements that match, and don't match, the provided predicate.

     - parameter predicate: A predicate used to filter matching and non-matching elements.

     - returns: A tuple of two streams of elements that match, and don't match, the provided predicate.
    */
    func partition(_ predicate: @escaping (E) throws -> Bool) -> (matches: Observable<E>, nonMatches: Observable<E>) {
        let stream = self.share()
        let hits = stream.filter(predicate)
        let misses = stream.filter {
            return !(try predicate($0))
        }
        return (hits, misses)
    }
}
