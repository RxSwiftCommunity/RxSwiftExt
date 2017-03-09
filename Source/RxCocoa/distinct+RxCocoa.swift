//
//  distinct+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/8/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
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

        return flatMap { element -> SharedSequence<SharingStrategy, Element> in
            if cache.contains(where: predicate) {
                return SharedSequence<SharingStrategy, Element>.empty()
            } else {
                cache.append(element)

                return SharedSequence<SharingStrategy, Element>.just(element)
            }
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

        return flatMap { element -> SharedSequence<SharingStrategy, Element> in
            if cache.contains(element) {
                return SharedSequence<SharingStrategy, Element>.empty()
            } else {
                cache.append(element)

                return SharedSequence<SharingStrategy, Element>.just(element)
            }
        }
    }
}
