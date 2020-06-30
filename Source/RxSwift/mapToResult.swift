//
//  mapToResult.swift
//  RxSwiftExt-iOS
//
//  Created by 이병찬 on 2020/06/29.
//  Copyright © 2020 RxSwiftCommunity. All rights reserved.
//

import RxSwift

public extension ObservableType {
    /**
     Returns an Observable that transformed event(`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from type of error emitted by Observable, an error occurs)
     - parameter catchErrorCastingFailed: Error casting failure handler function, producing another Observable.
     - returns: An Observable which only element of `Result` type is emitted
    */
    func mapToResult<E: Error>(errorType: E.Type, catchErrorCastingFailed handler: @escaping (Error) -> Observable<Result<Element, E>>) -> Observable<Result<Element, E>> {
        self.map { element -> Result<Element, E> in
            return .success(element)
        }.catchError { error -> Observable<Result<Element, E>> in
            guard let transformedError = error as? E else {
                return handler(error)
            }
            return .just(.failure(transformedError))
        }
    }
    
    /**
     Returns an Observable that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
     
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from type of error emitted by Observable, an error occurs)
     - returns: An Observable which only element of `Result` type is emitted
     */
    func mapToResult<E: Error>(errorType: E.Type) -> Observable<Result<Element, E>> {
        self.mapToResult(errorType: errorType) { unexpectedError in
            assertionFailure("unexpected error is emitted [expected type: \(errorType)] [emitted type: \(unexpectedError.self)]")
            return .empty()
        }
    }

    /**
     Returns an Observable that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter `catchErrorCastingFailedJustReturn`: A specific error value returned in case of error casting failure and after that complete the Observable.
     - returns: An Observable which only element of `Result` type is emitted
    */
    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn errorValue: E) -> Observable<Result<Element, E>> {
        self.mapToResult(errorType: E.self) { _ in
            return .just(.failure(errorValue))
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    /**
     Returns an Single that transformed event(`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from from type of error emitted by Single, an error occurs)
     - parameter catchErrorCastingFailed: Error casting failure handler function, producing another Single.
     - returns: An Single which only element of `Result` type is emitted
     */
    func mapToResult<E: Error>(errorType: E.Type, catchErrorCastingFailed handler: @escaping (Error) -> Single<Result<Element, E>>) -> Single<Result<Element, E>> {
        self.asObservable().mapToResult(errorType: errorType) { error in
            return handler(error).asObservable()
        }
        .asSingle()
    }
    
    /**
     Returns an Single that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from type of error emitted by Single, an error occurs)
     - returns: An Single which only element of `Result` type is emitted
     */
    func mapToResult<E: Error>(errorType: E.Type) -> Single<Result<Element, E>> {
        self.mapToResult(errorType: errorType) { unexpectedError in
            assertionFailure("unexpected error is emitted [expected type: \(errorType)] [emitted type: \(unexpectedError.self)]")
            return .never()
        }
    }

    /**
     Returns an Single that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter `catchErrorCastingFailedJustReturn`: A specific error value returned in case of error casting failure and after that complete the Single.
     - returns: An Single which only element of `Result` type is emitted
    */
    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn errorValue: E) -> Single<Result<Element, E>> {
        self.asObservable().mapToResult(catchErrorCastingFailedJustReturn: errorValue).asSingle()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait {
    /**
     Returns an Maybe that transformed event(`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from from type of error emitted by Maybe, an error occurs)
     - parameter catchErrorCastingFailed: Error casting failure handler function, producing another Maybe.
     - returns: An Single which only element of `Result` type is emitted
    */
    func mapToResult<E: Error>(errorType: E.Type, catchErrorCastingFailed handler: @escaping (Error) -> Maybe<Result<Element, E>>) -> Maybe<Result<Element, E>> {
        self.asObservable().mapToResult(errorType: errorType) { error in
            return handler(error).asObservable()
        }
        .asMaybe()
    }
    
    /**
     Returns an Maybe that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter errorType: A specific error type, will be `Result.Failure` type (If `type` is different from type of error emitted by Maybe, an error occurs)
     - returns: An Maybe which only element of `Result` type is emitted
     */
    func mapToResult<E: Error>(errorType: E.Type) -> Maybe<Result<Element, E>> {
        self.asObservable().mapToResult(errorType: errorType).asMaybe()
    }

    /**
     Returns an Maybe that transformed event (`Element`, `Error`) to element of `Result<Element, Error>`
    
     - parameter `catchErrorCastingFailedJustReturn`: A specific error value returned in case of error casting failure and after that complete the Maybe.
     - returns: An Maybe which only element of `Result` type is emitted
    */
    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn errorValue: E) -> Maybe<Result<Element, E>> {
        self.asObservable().mapToResult(catchErrorCastingFailedJustReturn: errorValue).asMaybe()
    }
}
