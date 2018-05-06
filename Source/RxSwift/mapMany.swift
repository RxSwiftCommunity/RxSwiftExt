//
//  mapMany.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 06.05.18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift

extension ObservableType where E: Collection {

    /**
     Projects elements of each element of an observable collection into a new form.
     - parameter transform: A transform function to apply to each source element.
     - returns: An observable collection whose elements are the result of invoking the transform function on each element of source.
     */

    public func mapMany<T>(_ transform: @escaping (E.Element) -> T) -> Observable<[T]> {
        return map { collection -> [T] in
            collection.map(transform)
        }
    }
}
