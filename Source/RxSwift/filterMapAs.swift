//
//  filterMapAs.swift
//  RxSwiftExt
//
//  Created by Jérôme Alves on 21/02/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType {

    /**
     Filters the items emitted by the source observable, only emitting those of the given type.

     - parameter type: A type whose matches the element type of the input sequence
     - returns: An observable sequence containing the elements 
     */
    public func filterMap<R>(as type: R.Type) -> Observable<R> {
        return self.filterMap {
            if let result = $0 as? R {
                return .map(result)
            } else {
              return .ignore
            }
        }
    }

    /**
     Filters the items emitted by the source observable, only emitting those of the given type.

     - parameter type: A type whose matches the element type of the input sequence
     - returns: An observable sequence containing the elements
     */
    public func ofType<R>(_ type: R.Type) -> Observable<R> {
        return filterMap(as: type)
    }

}
