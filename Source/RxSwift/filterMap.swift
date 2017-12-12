//
//  filterMap.swift
//  RxSwiftExt
//
//  Created by Jeremie Girault on 31/05/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxSwift

public enum FilterMap<Result> {
    case ignore
    case map(Result)

    fileprivate var asOperator: AnyOperator<Result> {
        switch self {
        case .ignore: return .filter
        case .map(let value): return .map(value)
        }
    }
}

extension ObservableType {

    /**
     Filters or Maps values from the source.
     - The returned Observable will error and complete with the source.
     - `next` values will be output according to the `transform` callback result:
        - returning `.ignore` will filter the value out of the returned Observable
        - returning `.map(newValue)` will propagate newValue through the returned Observable.
     */
    public func filterMap<T>(_ transform: @escaping (E) -> FilterMap<T>) -> Observable<T> {
        return flatMapSync { transform($0).asOperator }
    }
}
