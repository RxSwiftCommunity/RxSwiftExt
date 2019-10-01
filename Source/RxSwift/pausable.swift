//
//  pausable.swift
//  RxSwiftExt
//
//  Created by Jesse Farless on 12/09/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
	/**
    Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.

    Elements are ignored unless the second sequence has most recently emitted `true`.

    - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)

	- parameter pauser: The observable sequence used to pause the source observable sequence.
	- returns: The observable sequence which is paused based upon the pauser observable sequence.
	*/

    public func pausable<Pauser: ObservableType> (_ pauser: Pauser) -> Observable<Element> where Pauser.Element == Bool {
		return withLatestFrom(pauser) { element, paused in
				(element, paused)
			}
            .filter { _, paused in paused }
            .map { element, _ in element }
    }
}
