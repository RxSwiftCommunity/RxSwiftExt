//
//  overridingScan.swift
//  RxSwiftExt
//
//  Created by Sergey Smagleev on 02/27/19.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import RxSwift

private enum OverridingScanValue<T, U> {
    case ongoing(T)
    case overriding(U)
}

extension ObservableType {

    public func overridingScan<T, U: ObservableType>(_ overridingObservable: U,
                                                     _ seed: T,
                                                     accumulator: @escaping (T, Self.E) throws -> T )
        -> Observable<T> where U.E == T {
            return Observable.merge(
                self.map { OverridingScanValue<Self.E, T>.ongoing($0) },
                overridingObservable.map { OverridingScanValue<Self.E, T>.overriding($0) })
                .scan(seed, accumulator: { (total, current) -> T in
                    switch current {
                    case .ongoing(let value):
                        return try accumulator(total, value)
                    case .overriding(let value):
                        return value
                    }
                })
    }

}
