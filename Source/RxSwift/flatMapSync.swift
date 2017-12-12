//
//  flatMapSync.swift
//  RxSwiftExt
//
//  Created by Jeremie Girault on 31/05/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxSwift

/**
 Defines a synchronous custom operator output in the form of a Type
 */
public protocol CustomOperator {
    associatedtype Result

    /**
     Applies the operator instance output to a sink (eventually the observer)
     The sink is non-escaping for performance and safety reasons.
     */
    func apply(_ sink: (Result) -> Void)
}

/**
 A type-erased CustomOperator
 */
public struct AnyOperator<Result>: CustomOperator {

    /** The output sink type of this synchronous operator */
    public typealias Sink = (Result) -> Void

    private let _apply: (Sink) -> Void
    public init(_ apply: @escaping (Sink) -> Void) { self._apply = apply }

    // CustomOperator implementation
    public func apply(_ sink: Sink) { _apply(sink) }
}

extension CustomOperator {

    /** Filters values out from the output of the Observable */
    public static var filter: AnyOperator<Result> {
        return AnyOperator { _ in }
    }

    /** Replaces values in the output of the Observable */
    public static func map(_ values: Result...) -> AnyOperator<Result> {
        return AnyOperator { sink in values.forEach { sink($0) } }
    }
}

extension ObservableType {

    /**
     FlatMaps values from a stream synchronously using CustomOperator type.
     - The returned Observable will error and complete with the source.
     - `next` values will be transformed by according to the CustomOperator application rules.

     see filterMap for an example of a custom operator
     */
    public func flatMapSync<O: CustomOperator>(_ transform: @escaping (E) -> O) -> Observable<O.Result> {
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
