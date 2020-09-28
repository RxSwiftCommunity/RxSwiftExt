//
//  distinct.swift
//  RxSwiftExt
//
//  Created by Segii Shulga on 5/4/16.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - parameter predicate: predicate determines whether element distinct
     
     - returns: An observable sequence only containing the distinct contiguous elements, based on predicate, from the source sequence.
     */
    public func distinct(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
        var cache = [Element]()
        return filter { element -> Bool in
            let emitted = try cache.contains(where: predicate)
            if !emitted { cache.append(element) }
            return !emitted
        }
    }
}

extension Observable where Element: Hashable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = Set<Element>()
        return filter { element in cache.insert(element).inserted }
    }
}

extension Observable where Element: Equatable {
    /**
     Suppress duplicate items emitted by an Observable
     - seealso: [distinct operator on reactivex.io](http://reactivex.io/documentation/operators/distinct.html)
     - returns: An observable sequence only containing the distinct contiguous elements, based on equality operator, from the source sequence.
     */
    public func distinct() -> Observable<Element> {
        var cache = [Element]()
        return filter { element -> Bool in
            let emitted = cache.contains(element)
            if !emitted { cache.append(element) }
            return !emitted
        }
    }
}
