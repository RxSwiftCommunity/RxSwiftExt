//
//  cascade.swift
//  RxSwiftExtDemo
//
//  Created by Florent Pillet on 17/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element : ObservableType {
	
	typealias T = Element.E
	
	/**
	Cascade through a sequence of observables: every observable that sends a `next` value becomes the "current"
	observable (like in `switchLatest`), and the subscription to all previous observables in the sequence is disposed.

	This allows subscribing to multiple observable sequences while irrevocably switching to the next when it starts emitting. If any of the
	currently subscribed-to sequences errors, the error is propagated to the observer and the sequence terminates.
	
	- parameter observables: a sequence of observables which will all be immediately subscribed to
	- returns: An observable sequence that contains elements from the latest observable sequence that emitted elements
	*/

	@warn_unused_result(message="http://git.io/rxs.uo")
	public static func cascade<S : SequenceType where S.Generator.Element == Element, S.Generator.Element.E == T>(all : S) -> Observable<T> {
		let observables = Array(all)
		if observables.isEmpty {
			return Observable<T>.empty()
		}

		return Observable<T>.create { observer in
			var previous = 0
			var current = 0
			let lock = NSRecursiveLock()
			var subscriptions = [Disposable?](count: observables.count, repeatedValue: nil)
			lock.lock()
			defer { lock.unlock() }

			for i in 0 ..< observables.count {
				let index = i
				var complete = false
				let disposable = observables[index].subscribe { event in
					lock.lock()
					defer { lock.unlock() }
					sw: switch event {
					case .Next(let element):
						if index >= current {
							// dispose subscriptions to sequences we now ignore
							for toDispose in previous ..< index {
								subscriptions[toDispose]?.dispose()
							}
							previous = current
							current = index
							observer.onNext(element)
						}
					case .Completed:
						complete = true
						if index >= current {
							subscriptions[index]?.dispose()
                            subscriptions[index] = nil
							for j in current ..< subscriptions.count {
								if subscriptions[j] != nil {
									break sw
								}
							}
							observer.onCompleted()
						}
						
					case .Error(let error):
						observer.onError(error)
					}
				}
				if !complete {
					subscriptions[index] = disposable
				}
			}
			
			return AnonymousDisposable {
				subscriptions.forEach { $0?.dispose() }
			}
		}
	}
}

extension ObservableType {
	
	/**
	Cascade through a sequence of observables: every observable that sends a `next` value becomes the "current"
	observable (like in `switchLatest`), and the subscription to all previous observables in the sequence is disposed.
	
	This allows subscribing to multiple observable sequences while irrevocably switching to the next when it starts emitting. If any of the
	currently subscribed-to sequences errors, the error is propagated to the observer and the sequence terminates.
	
	- parameter observables: a sequence of observables which will all be immediately subscribed to
	- returns: An observable sequence that contains elements from the latest observable sequence that emitted elements
	*/
	@warn_unused_result(message="http://git.io/rxs.uo")
    public func cascade<S : SequenceType where S.Generator.Element == Self>(next : S) -> Observable<E> {
        return Observable.cascade([self.asObservable()] + Array(next).map { $0.asObservable() })
	}

}