//
//  ignoreErrors.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 18/05/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import RxSwift

extension ObservableType {
    /**
     Unconditionally ignore all errors produced by the source observable, effectively producing a sequence
     that never fails (any error will simply have no effect on the sequence).
     
     - returns: An observable sequence that never fails
     - seealso: `retry` operator
     */
    
    public func ignoreErrors() -> Observable<E> {
        return retry()
    }
    
    /**
     Conditionally ignore errors produced by the source observable
     
     - parameter predicate a predicate called when an error occurs and returns `true` to ignore the error (continuing), `false` to terminate the sequence with the given error.
     - returns: An observable sequence that errors only when `predicate` returns `false`
     */
    
    public func ignoreErrors(_ predicate : @escaping (Error) -> Bool) -> Observable<E> {
        return retryWhen {
            return $0.flatMap { error -> Observable<Bool> in
                return predicate(error) ?  Observable.just(true) : Observable<Bool>.error(error)
            }
        }
    }
}
