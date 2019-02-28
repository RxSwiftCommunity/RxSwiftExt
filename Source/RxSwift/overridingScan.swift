//
//  overridingScan.swift
//  RxSwiftExt
//
//  Created by Sergey Smagleev on 02/27/19.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import RxSwift

private enum OverridingScanValue<T, U> {
    case sequential(T)
    case overriding(U)
}

extension ObservableType {

    /**
     Applies an accumulator function over an observable sequence and returns each intermediate result that can be overridden by values from another observable.
     
     The behavior is identical to `scan`, except the result of applying the accumulator function can be overridden by an arbitrary value from another observable.
     
     - seealso: [scan operator on reactivex.io](http://reactivex.io/documentation/operators/scan.html)
     
     - parameter overridingObservable: An observable which can override the current result of the accumulator function.
     - parameter seed: The initial accumulator value.
     - parameter accumulator: An accumulator function to be invoked on each element.
     - returns: An observable sequence containing the accumulated values.
     */
    public func overridingScan<T, U: ObservableType>(_ overridingObservable: U,
                                                     _ seed: T,
                                                     accumulator: @escaping (T, Self.E) throws -> T )
        -> Observable<T> where U.E == T {
            return Observable.merge(
                self.map { OverridingScanValue<Self.E, T>.sequential($0) },
                overridingObservable.map { OverridingScanValue<Self.E, T>.overriding($0) })
                .scan(seed, accumulator: { (total, current) -> T in
                    switch current {
                    case .sequential(let value):
                        return try accumulator(total, value)
                    case .overriding(let value):
                        return value
                    }
                })
    }

}
