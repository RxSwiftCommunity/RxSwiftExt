//
//  repeatWithBehavior.swift
//
//  Created by Marin Todorov
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

public typealias RepeatPredicate = () -> Bool

/*
Uses RepeatBehavior and RepeatPredicate defined in retryWithBehavior
*/

private enum RepeatError: ErrorType {
    case catchable
}

extension ObservableType {

    /**
	Repeats the source observable sequence using given behavior in case of an error or until it successfully terminated
	- parameter behavior: Behavior that will be used in case of an error
	- parameter scheduler: Schedular that will be used for delaying subscription after error
	- parameter shouldRetry: Custom optional closure for checking error (if returns true, repeat will be performed)
	- returns: Observable sequence that will be automatically repeat if error occurred
	*/
	@warn_unused_result(message="http://git.io/rxs.uo")
	public func repeatWithBehavior(behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRepeat : RepeatPredicate? = nil) -> Observable<E> {
		return repeatWithBehavior(1, behavior: behavior, scheduler: scheduler, shouldRepeat: shouldRepeat)
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
	internal func repeatWithBehavior(currentRepeat: UInt, behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRepeat : RepeatPredicate? = nil)
		-> Observable<E> {
			guard currentRepeat > 0 else { return Observable.empty() }
			
			// calculate conditions for bahavior
			let conditions = behavior.calculateConditions(currentRepeat)

            return concat(Observable.error(RepeatError.catchable))
                .catchError {error in
                    //if observable errors, forward the error
                    guard error is RepeatError else {
                        return Observable.error(error)
                    }

                    //repeat
                    guard conditions.maxCount > currentRepeat else { return Observable.empty() }

                    if let shouldRepeat = shouldRepeat where !shouldRepeat() {
                        // also return error if predicate says so
                        return Observable.empty()
                    }

                    guard conditions.delay > 0.0 else {
                        // if there is no delay, simply retry
                        return self.repeatWithBehavior(currentRepeat + 1, behavior: behavior, scheduler: scheduler, shouldRepeat: shouldRepeat)
                    }

                    // otherwise retry after specified delay
                    return Observable<Void>.just().delaySubscription(conditions.delay, scheduler: scheduler).flatMapLatest {
                        self.repeatWithBehavior(currentRepeat + 1, behavior: behavior, scheduler: scheduler, shouldRepeat: shouldRepeat)
                    }
                }
	}
}