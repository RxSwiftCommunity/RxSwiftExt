//
//  customOperator.swift
//  RxSwiftExt
//
//  Created by Jeremie Girault on 31/05/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import RxSwift

/**
 A Custom Operator in the form of a Type
 */
public protocol CustomOperator {
    associatedtype Result

    /**
     Applies the operator output to a sink (eventually the observer)
     The sink is non-escaping for performance and safety reasons.
     */
    func apply(_ sink: (Result) -> Void)
}

extension ObservableType {

    /**
     Create a custom operator from a CustomOperator type.
     - The returned Observable will error and complete with the source.
     - `next` values will be transformed by according to the CustomOperator application rules.

     see filterMap for an example of a custom operator
     */
    public func customOperator<T: CustomOperator>(_ transform: @escaping (E) -> T) -> Observable<T.Result> {
        return Observable.create { observer in
            return self.subscribe { event in
                switch event {
                case .next(let element): transform(element).apply { observer.onNext($0) }
                case .completed: observer.onCompleted()
                case .error(let error): observer.onError(error)
                }
            }
        }
    }
}
