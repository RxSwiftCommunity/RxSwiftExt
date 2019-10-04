//
//  zipWith.swift
//  RxSwiftExt
//
//  Created by Arjan Duijzer on 26/12/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableConvertibleType {

    /**
     Merges the specified observable sequences into one observable sequence by using the selector function whenever all of the observable sequences have produced an element at a corresponding index.

     - seealso: [zip operator on reactivex.io](http://reactivex.io/documentation/operators/zip.html)

     - Parameters:
        - with: A second Observable<T> to zip with `self`
        - resultSelector: Function to invoke for each series of elements at corresponding indexes in the sources.

     - Returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
     */
    public func zip<Other: ObservableConvertibleType, ResultType>(with second: Other, resultSelector: @escaping (Element, Other.Element) throws -> ResultType) -> Observable<ResultType> {
        return Observable.zip(asObservable(), second.asObservable(), resultSelector: resultSelector)
    }
}
