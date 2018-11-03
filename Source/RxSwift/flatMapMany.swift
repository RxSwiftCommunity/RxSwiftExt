//
//  flatMapMany.swift
//  RxSwiftExt-iOS
//
//  Created by Yuto Akiba on 2018/11/03.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType where E: Collection {
    /**
     Projects each element of an observable collection to an observable collection and merges the resulting observable collections into one observable collection.

     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    public func flatMapMany<O>(_ selector: @escaping (E.Element) throws -> O) -> Observable<[O.E]> where O: ObservableConvertibleType {
        return flatMap { collection -> Observable<[O.E]> in
            let new = try collection.map(selector)
            return Observable.from(new).merge().toArray()
        }
    }
}
