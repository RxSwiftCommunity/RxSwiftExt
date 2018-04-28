//
//  toSortedArray.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 17.02.18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where E: Sequence, E.Iterator.Element: Comparable {
    /**
     Transforms an observable of comparables into an observable of ordered arrays.

     - parameter ascending: Defined the sorting direction. Defaults to ascending.
     - returns: The sorted observable.
    */
    public func toSortedArray<T>(
        ascending: Bool = true
        ) -> Observable<[T]> where E.Iterator.Element == T {
        return map {
            $0.sorted(by: { ascending ? $0 < $1 : $0 > $1 })
        }
    }
    /**
     Transforms an observable of comparables into an observable of ordered arrays by using the function passed in.
     
     - parameter areInIncreasingOrder: A function to compare to elements.
     - returns: The sorted observable.
     */
    public func toSortedArray<T>(
        _ areInIncreasingOrder: @escaping (T, T) -> Bool
        ) -> Observable<[T]> where E.Iterator.Element == T {
        return self.map { $0.sorted(by: areInIncreasingOrder) }
    }
}
