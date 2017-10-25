//
//  unwrap.swift
//  RxSwiftExt
//
//  Created by Marin Todorov on 4/7/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension Observable where E: OptionalType {
    
    public func unwrap() -> Observable<E.Wrapped> {
        return self.filter { $0.value != nil }.map { $0.value! }
    }
    
}
