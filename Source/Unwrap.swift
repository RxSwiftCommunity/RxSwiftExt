//
//  RxExt.swift
//  rxswiftextplayground
//
//  Created by Marin Todorov on 4/7/16.
//  Copyright © 2016 Underplot. All rights reserved.
//

import Foundation
import RxSwift

////unwrap
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

extension Observable where Element : Optionable {
    public func unwrap() -> Observable<Element.WrappedType> {
        return self
            .filter {value in
                return !value.isEmpty()
            }
            .map {value -> Element.WrappedType in
                value.unwrap()
        }
    }
}
////
