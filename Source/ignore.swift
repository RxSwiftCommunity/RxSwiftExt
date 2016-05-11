//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

extension ObservableType where E : Equatable {
	
	@warn_unused_result(message="http://git.io/rxs.uo")
	public func ignore(valuesToIgnore: E ...) -> Observable<E> {
        return self.asObservable().filter { !valuesToIgnore.contains($0) }
    }

	@warn_unused_result(message="http://git.io/rxs.uo")
	public func ignore<S: SequenceType where S.Generator.Element == E>(valuesToIgnore : S) -> Observable<E> {
		return self.asObservable().filter { !valuesToIgnore.contains($0) }
	}
}
