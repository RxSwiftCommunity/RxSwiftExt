//
//  mapToResult.swift
//  RxSwiftExt-iOS
//
//  Created by 이병찬 on 2020/06/29.
//  Copyright © 2020 RxSwiftCommunity. All rights reserved.
//

import RxSwift

public extension ObservableType {
    func mapToResult<E: Error>(type: E.Type) -> Observable<Result<Element, E>> {
        self.map { element -> Result<Element, E> in
            return .success(element)
        }.catchError { error -> Observable<Result<Element, E>> in
            guard let transformedError = error as? E else {
                assertionFailure("예상한 Error의 타입\(type)과 다른 타입의 Error\(error.self)가 방출되었습니다.")
                return .never()
            }
            return .just(.failure(transformedError))
        }
    }

    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn defaultError: E) -> Observable<Result<Element, E>> {
        self.map { element -> Result<Element, E> in
            return .success(element)
        }.catchError { error -> Observable<Result<Element, E>> in
            let transformedError = (error as? E) ?? defaultError
            return .just(.failure(transformedError))
        }
    }
}

public extension PrimitiveSequence where Trait == SingleTrait {
    func mapToResult<E: Error>(type: E.Type) -> Single<Result<Element, E>> {
        self.asObservable().mapToResult(type: type).asSingle()
    }

    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn defaultError: E) -> Single<Result<Element, E>> {
        self.asObservable().mapToResult(catchErrorCastingFailedJustReturn: defaultError).asSingle()
    }
}

public extension PrimitiveSequence where Trait == MaybeTrait {
    func mapToResult<E: Error>(type: E.Type) -> Maybe<Result<Element, E>> {
        self.asObservable().mapToResult(type: type).asMaybe()
    }

    func mapToResult<E: Error>(catchErrorCastingFailedJustReturn defaultError: E) -> Maybe<Result<Element, E>> {
        self.asObservable().mapToResult(catchErrorCastingFailedJustReturn: defaultError).asMaybe()
    }
}
