//
//  filterMapAs.swift
//  RxSwiftExt
//
//  Created by Jérôme Alves on 21/02/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift

extension ObservableType {

    /**
     Takes a sequence of elements and returns a sequence of elements casted as given type, filtering out any non castable values.

     - parameter type: A type whose matches the element type of the input sequence
     - returns: An observable sequence containing the elements 
     */
    public func filterMap<R>(as type: R.Type) -> Observable<R> {
        return self.filterMap {
            guard let result = $0 as? R else { return .ignore }
            return .map(result)
        }
    }

}
