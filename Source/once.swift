//
//  once.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 12/04/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

extension Observable {

	/**
	 Returns an observable sequence that contains a single element. This element will be delivered to the first observer
	 that subscribes. Further subscriptions to the same observable will get an empty sequence.

	 In most cases, you want to use `Observable.just()`. This one is really for specific cases where you need to guarantee
	 unique delivery of a value.

	 - seealso: [just operator on reactivex.io](http://reactivex.io/documentation/operators/just.html)

	 - parameter element: Single element in the resulting observable sequence.
	 - returns: An observable sequence containing the single specified element delivered once.
	*/
	
	public static func once(_ element: E) -> Observable<E> {
		var delivered : UInt32 = 0
		return create { observer in
			let wasDelivered = OSAtomicOr32OrigBarrier(1, &delivered)
			if wasDelivered == 0 {
				observer.onNext(element)
			}
			observer.onCompleted()
            return NopDisposable.instance
		}
	}

}

