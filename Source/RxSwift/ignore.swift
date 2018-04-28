//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E: Equatable {

	public func ignore(_ valuesToIgnore: E ...) -> Observable<E> {
        return self.asObservable().filter { !valuesToIgnore.contains($0) }
    }

	public func ignore<S: Sequence>(_ valuesToIgnore: S) -> Observable<E> where S.Iterator.Element == E {
		return self.asObservable().filter { !valuesToIgnore.contains($0) }
	}
}
