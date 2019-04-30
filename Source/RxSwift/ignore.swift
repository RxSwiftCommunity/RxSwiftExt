//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where Element: Equatable {
	public func ignore(_ valuesToIgnore: Element...) -> Observable<Element> {
        return self.asObservable().filter { !valuesToIgnore.contains($0) }
    }

	public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> Observable<Element> where Sequence.Element == Element {
		return self.asObservable().filter { !valuesToIgnore.contains($0) }
	}
}
