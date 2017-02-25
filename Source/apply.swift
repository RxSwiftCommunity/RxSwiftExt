//
//  apply.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 2/22/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    /// Apply a transformation function to the Observable.
    public func apply<T>(_ transform: (Observable<Self.E>) -> Observable<T>) -> Observable<T> {
        return transform(self.asObservable())
    }
}
