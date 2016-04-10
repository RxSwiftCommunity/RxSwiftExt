//
//  unwrap.swift
//  RxSwift+Ext
//
//  Created by Marin Todorov on 4/7/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

public protocol Optionable
{
    associatedtype WrappedType
    func unwrap() -> WrappedType
    func isEmpty() -> Bool
}

extension Optional : Optionable
{
    public typealias WrappedType = Wrapped
    public func unwrap() -> WrappedType {
        return self!
    }
    
    public func isEmpty() -> Bool {
        return !(flatMap({_ in true})?.boolValue == true)
    }
}

extension ObservableType where E : Optionable {
    public func unwrap() -> Observable<E.WrappedType> {
        return self
            .filter {value in
                return !value.isEmpty()
            }
            .map { value -> E.WrappedType in
                value.unwrap()
        }
    }
}
