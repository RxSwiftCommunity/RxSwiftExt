//
//  ObservableType+Weak.swift
//  RxSwiftExtDemo
//
//  Created by Ian Keen on 17/04/2016.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
	/**
	Leverages instance method currying to provide a weak wrapper around an instance function
	
	- parameter obj:    The object that owns the function
	- parameter method: The instance function represented as `InstanceType.instanceFunc`
	*/
	fileprivate func weakify<A: AnyObject, B>(_ obj: A, method: ((A) -> (B) -> Void)?) -> ((B) -> Void) {
		return { [weak obj] value in
			guard let obj = obj else { return }
			method?(obj)(value)
		}
	}
	
	/**
	Subscribes an event handler to an observable sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter on: Function to invoke on `weak` for each event in the observable sequence.
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	
	public func subscribe<A: AnyObject>(weak obj: A, _ on: @escaping (A) -> (RxSwift.Event<Self.E>) -> Void) -> Disposable {
		return self.subscribe(weakify(obj, method: on))
	}
	
	/**
	Subscribes an element handler, an error handler, a completion handler and disposed handler to an observable sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
	- parameter onError: Function to invoke on `weak` upon errored termination of the observable sequence.
	- parameter onCompleted: Function to invoke on `weak` upon graceful termination of the observable sequence.
	- parameter onDisposed: Function to invoke on `weak` upon any type of termination of sequence (if the sequence has
	gracefully completed, errored, or if the generation is cancelled by disposing subscription)
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	
	public func subscribe<A: AnyObject>(
		weak obj: A,
		     onNext: ((A) -> (Self.E) -> Void)? = nil,
		     onError: ((A) -> (Error) -> Void)? = nil,
		     onCompleted: ((A) -> () -> Void)? = nil,
		     onDisposed: ((A) -> () -> Void)? = nil) -> Disposable {
		
		let disposable: Disposable
		
		if let disposed = onDisposed {
			disposable = Disposables.create(with: weakify(obj, method: disposed))
		}
		else {
			disposable = Disposables.create()
		}
		
		let observer = AnyObserver { [weak obj] (e: RxSwift.Event<Self.E>) in
			guard let obj = obj else { return }
			switch e {
			case .next(let value):
				onNext?(obj)(value)
			case .error(let e):
				onError?(obj)(e)
				disposable.dispose()
			case .completed:
				onCompleted?(obj)()
				disposable.dispose()
			}
		}
		
		return Disposables.create(self.asObservable().subscribe(observer), disposable)
	}
	
	/**
	Subscribes an element handler to an observable sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter onNext: Function to invoke on `weak` for each element in the observable sequence.
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	
	public func subscribeNext<A: AnyObject>(weak obj: A, _ onNext: @escaping (A) -> (Self.E) -> Void) -> Disposable {
        return self.subscribe(onNext: weakify(obj, method: onNext))
	}
	
	/**
	Subscribes an error handler to an observable sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter onError: Function to invoke on `weak` upon errored termination of the observable sequence.
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	
	public func subscribeError<A: AnyObject>(weak obj: A, _ onError: @escaping (A) -> (Error) -> Void) -> Disposable {
        return self.subscribe(onError: weakify(obj, method: onError))
	}
	
	/**
	Subscribes a completion handler to an observable sequence.
	
	- parameter weak: Weakly referenced object containing the target function.
	- parameter onCompleted: Function to invoke on `weak` graceful termination of the observable sequence.
	- returns: Subscription object used to unsubscribe from the observable sequence.
	*/
	
	public func subscribeCompleted<A: AnyObject>(weak obj: A, _ onCompleted: @escaping (A) -> () -> Void) -> Disposable {
        return self.subscribe(onCompleted: weakify(obj, method: onCompleted))
	}
}
