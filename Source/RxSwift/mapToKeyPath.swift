//
//  mapToKeyPath.swift
//  RxSwiftExt-iOS
//
//  Created by Michael Avila on 2/8/18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxSwift

extension ObservableType {

    /**
     Returns an observable sequence containing as many elements as its input but all of them are mapped to the result of the given keyPath

     - parameter keyPath: A key path whose root type matches the element type of the input sequence
     - returns: An observable squence containing the values pointed to by the key path
     */
    public func mapTo<R>(_ keyPath: KeyPath<E, R>) -> Observable<R> {
        return self.map { $0[keyPath: keyPath] }
    }
}
