//
//  and.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 19.10.17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//
import Foundation
import RxSwift

extension Observable where E == Bool {

	public func and<C: Collection>(_ collection: C) -> Observable<Bool> where C.Iterator.Element: ObservableType, C.Iterator.Element.E == E {
		return Observable.combineLatest(collection).map { $0.reduce(true, { $0 && $1 }) }
	}

	public func and<O: ObservableType>(_ sources: O ...) -> Observable<Bool> where O.E == Bool {
		return self.and(sources)
	}

}
