//
//  count.swift
//  RxSwiftExt
//
//  Created by Fred on 06/11/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /**
     Count the number of items emitted by an Observable
     - seealso: [count operator on reactivex.io](http://reactivex.io/documentation/operators/count.html)
     - returns: An Observable sequence containing a value that represents how many elements in the specified observable sequence satisfy a condition if provided, else the count of items.
     */
    public func count() -> Observable<Int> {
        return reduce(0) { count, _ in count + 1 }
    }
    /**
     Count the number of items emitted by an Observable
     - seealso: [count operator on reactivex.io](http://reactivex.io/documentation/operators/count.html)
     - parameter predicate: predicate determines what elements to be counted.

     - returns: An Observable sequence containing a value that represents how many elements in the specified observable sequence satisfy a condition if provided, else the count of items.
     */
    public func count(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Int> {
        return filter(predicate).count()
    }
}
