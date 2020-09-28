//
//  distinct+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/8/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxCocoa

extension SharedSequence {
    /**
     Suppress duplicate items emitted by an SharedSequence
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - parameter predicate: predicate determines whether element distinct

     - returns: An shared sequence only containing the distinct contiguous elements, based on predicate, from the source sequence.
     */
    public func distinct(_ predicate: @escaping (Element) -> Bool) -> SharedSequence<SharingStrategy, Element> {
        var cache = [Element]()

        return filter { element -> Bool in
            let emitted = cache.contains(where: predicate)
            if !emitted { cache.append(element) }
            return !emitted
        }
    }
}

extension SharedSequence where Element: Equatable {
    /**
     Suppress duplicate items emitted by an SharedSequence
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An shared sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> SharedSequence<SharingStrategy, Element> {
        var cache = [Element]()

        return filter { element -> Bool in
            let emitted = cache.contains(element)
            if !emitted { cache.append(element) }
            return !emitted
        }
    }
}
