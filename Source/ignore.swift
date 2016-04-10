//
//  ignore.swift
//  RxSwift+Ext
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

extension ObservableType where E : Equatable {
	
    public func ignore(valuesToIgnore: E ...) -> Observable<E> {
        return self.asObservable().filter { !valuesToIgnore.contains($0) }
    }
	
	public func ignore<S: SequenceType where S.Generator.Element == E>(valuesToIgnore : S) -> Observable<E> {
		return self.asObservable().filter { !valuesToIgnore.contains($0) }
	}
}
