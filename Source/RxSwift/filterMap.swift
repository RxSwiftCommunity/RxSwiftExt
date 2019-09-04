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
}

extension ObservableType {

    /**
     Filters or Maps values from the source.
     - The returned Observable will complete with the source.  It will error with the source or with error thrown by transform callback.
     - `next` values will be output according to the `transform` callback result:
        - returning `.ignore` will filter the value out of the returned Observable
        - returning `.map(newValue)` will propagate newValue through the returned Observable.
     */
    public func filterMap<Result>(_ transform: @escaping (Element) throws -> FilterMap<Result>) -> Observable<Result> {
        return compactMap { element in
            switch try transform(element) {
            case .ignore:
                return nil
            case let .map(result):
                return result
            }
        }
    }
}
