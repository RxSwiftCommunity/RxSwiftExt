//
//  partition.swift
//  RxSwiftExt
//
//  Created by Shai Mishali on 24/11/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

public extension ObservableType {
    /**
     Partition a stream into two separate streams of elements that match, and don't match, the provided predicate.

     - parameter predicate: A predicate used to filter matching and non-matching elements.

     - returns: A tuple of two streams of elements that match, and don't match, the provided predicate.
    */
    func partition(_ predicate: @escaping (Element) throws -> Bool) -> (matches: Observable<Element>, nonMatches: Observable<Element>) {
        let stream = self.map { ($0, try predicate($0)) }.share()

        let hits = stream.filter { $0.1 }.map { $0.0 }
        let misses = stream.filter { !$0.1 }.map { $0.0 }

        return (hits, misses)
    }
}
