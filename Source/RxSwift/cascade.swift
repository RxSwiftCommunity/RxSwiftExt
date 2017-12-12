//
//  cascade.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 17/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element : ObservableType {

	public typealias T = Element.E

	/**
	Cascade through a sequence of observables: every observable that sends a `next` value becomes the "current"
	observable (like in `switchLatest`), and the subscription to all previous observables in the sequence is disposed.
	
	This allows subscribing to multiple observable sequences while irrevocably switching to the next when it starts emitting. If any of the
	currently subscribed-to sequences errors, the error is propagated to the observer and the sequence terminates.
	
	- parameter observables: a sequence of observables which will all be immediately subscribed to
	- returns: An observable sequence that contains elements from the latest observable sequence that emitted elements
	*/
	public static func cascade<S: Sequence>(_ observables: S) -> Observable<T> where S.Iterator.Element == Element {
        let flow = Array(observables)
        if flow.isEmpty {
            return Observable<T>.empty()
        }

        return Observable<T>.create { observer in
            var current = 0, initialized = false
            var subscriptions: [SerialDisposable?] = flow.map { _ in SerialDisposable() }

            let lock = NSRecursiveLock()
            lock.lock()
            defer { lock.unlock() }

            for i in 0 ..< flow.count {
                let index = i
                let disposable = flow[index].subscribe { event in
                    lock.lock()
                    defer { lock.unlock() }

                    switch event {
                    case .next(let element):
                        while current < index {
                            subscriptions[current]?.dispose()
                            subscriptions[current] = nil
                            current += 1
                        }
                        if index == current {
                            assert(subscriptions[index] != nil)
                            observer.onNext(element)
                        }

                    case .completed:
                        if index >= current {
                            if initialized {
                                subscriptions[index]?.dispose()
                                subscriptions[index] = nil
                                for next in current ..< subscriptions.count where subscriptions[next] != nil {
                                    return
                                }
                                observer.onCompleted()
                            }
                        }

                    case .error(let error):
                        observer.onError(error)
                    }
                }
                if let serialDisposable = subscriptions[index] {
                    serialDisposable.disposable = disposable
                } else {
                    disposable.dispose()
                }
            }

            initialized = true

            for i in 0 ..< flow.count where subscriptions[i] != nil {
                return Disposables.create {
                    subscriptions.forEach { $0?.dispose() }
                }
            }

            observer.onCompleted()
            return Disposables.create()
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
    public func cascade<S: Sequence>(_ next: S) -> Observable<E> where S.Iterator.Element == Self {
        return Observable.cascade([self.asObservable()] + Array(next).map { $0.asObservable() })
    }
}
