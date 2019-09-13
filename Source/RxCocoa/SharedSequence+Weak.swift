//
//  ObservableType+Weak.swift
//  RxSwiftExt
//
//  Created by George Kiriy on 13/09/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequence {
    /**
     Leverages instance method currying to provide a weak wrapper around an instance function

     - parameter obj:    The object that owns the function
     - parameter method: The instance function represented as `InstanceType.instanceFunc`
     */
    fileprivate func weakify<A: AnyObject, B>(_ obj: A, method: ((A) -> (B) -> Void)?) -> ((B) -> Void)? {
        return method.map { method in
            return { [weak obj] value in
                guard let obj = obj else { return }
                method(obj)(value)
            }
        }
    }

    fileprivate func weakify<A: AnyObject>(_ obj: A, method: ((A) -> () -> Void)?) -> (() -> Void)? {
        return method.map { method in
            return { [weak obj] in
                guard let obj = obj else { return }
                method(obj)()
            }
        }
    }
}

extension SharedSequence where SharingStrategy == SignalSharingStrategy {
    /**
     Subscribes an element handler, an error handler, a completion handler and disposed handler to a Signal sequence.

     - parameter weak: Weakly referenced object containing the target function.
     - parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
     - parameter onCompleted: Function to invoke on `weak` upon graceful termination of the observable sequence.
     - parameter onDisposed: Function to invoke on `weak` upon any type of termination of sequence (if the sequence has
     gracefully completed, errored, or if the generation is cancelled by disposing subscription)
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    public func emit<A: AnyObject>(
        weak obj: A,
        onNext: ((A) -> (Element) -> Void)? = nil,
        onCompleted: ((A) -> () -> Void)? = nil,
        onDisposed: ((A) -> () -> Void)? = nil
    ) -> Disposable {
        return emit(
            onNext: weakify(obj, method: onNext),
            onCompleted: weakify(obj, method: onCompleted),
            onDisposed: weakify(obj, method: onDisposed)
        )
    }
}

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
	/**
     Subscribes an element handler, an error handler, a completion handler and disposed handler to a Driver sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
	- parameter onCompleted: Function to invoke on `weak` upon graceful termination of the observable sequence.
	- parameter onDisposed: Function to invoke on `weak` upon any type of termination of sequence (if the sequence has
	gracefully completed, errored, or if the generation is cancelled by disposing subscription)
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	public func drive<A: AnyObject>(
        weak obj: A,
        onNext: ((A) -> (Element) -> Void)? = nil,
        onCompleted: ((A) -> () -> Void)? = nil,
        onDisposed: ((A) -> () -> Void)? = nil
    ) -> Disposable {
        return drive(
            onNext: weakify(obj, method: onNext),
            onCompleted: weakify(obj, method: onCompleted),
            onDisposed: weakify(obj, method: onDisposed)
        )
	}
}
