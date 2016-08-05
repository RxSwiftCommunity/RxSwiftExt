//
//  repeatWithBehavior.swift
//
//  Created by Marin Todorov
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

/*
Uses RepeatBehavior and RepeatPredicate defined in retryWithBehavior
*/

extension ObservableType {
	/**
	Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
	- parameter behavior: Behavior that will be used in case of an error
	- parameter scheduler: Schedular that will be used for delaying subscription after error
	- parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
	- returns: Observable sequence that will be automatically repeat if error occurred
	*/
	@warn_unused_result(message="http://git.io/rxs.uo")
	public func `repeat`(behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRetry : RepeatPredicate? = nil) -> Observable<E> {
		return `repeat`(1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
	}
	
	/**
	Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
	- parameter currentAttempt: Number of current attempt
	- parameter behavior: Behavior that will be used in case of an error
	- parameter scheduler: Schedular that will be used for delaying subscription after error
	- parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
	- returns: Observable sequence that will be automatically repeat if error occurred
	*/
	@warn_unused_result(message="http://git.io/rxs.uo")
	internal func `repeat`(currentRepeat: UInt, behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRetry : RepeatPredicate? = nil)
		-> Observable<E> {
			guard currentRepeat > 0 else { return Observable.empty() }
			
			// calculate conditions for bahavior
			let conditions = behavior.calculateConditions(currentRepeat)
			
			return catchError { error -> Observable<E> in
				// return error if exceeds maximum amount of retries
				guard conditions.maxCount > currentRepeat else { return Observable.error(error) }
				
				if let shouldRetry = shouldRetry where !shouldRetry(error) {
					// also return error if predicate says so
					return Observable.error(error)
				}

				guard conditions.delay > 0.0 else {
					// if there is no delay, simply retry
					return self.retry(currentRepeat + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
				}
				
				// otherwise retry after specified delay
				return Observable<Void>.just().delaySubscription(conditions.delay, scheduler: scheduler).flatMapLatest {
					self.retry(currentRepeat + 1, behavior: behavior, scheduler: scheduler, shouldRetry: shouldRetry)
				}
			}
	}
}