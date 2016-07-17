//
//  retryWithBehavior.swift
//  Pods
//
//  Created by Anton Efimenko on 17.07.16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

public enum RepeatBehavior {
	case Immediate (maxAttemptCount: UInt)
	case Delayed (maxAttemptCount: UInt, time: Double)
	case ExponentialDelayed (maxAttemptCount: UInt, initial: Double, multiplier: Double)
	case CustomTimerDelayed (maxAttemptCount: UInt, delayCalculator:(UInt -> Double))
}

public typealias RepeatPredicate = (ErrorType) -> Bool

extension ObservableType {
	// retry with behavior on .Error. Complete on .Completed
	public func retry(behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRetry : RepeatPredicate? = nil) -> Observable<E> {
		return retry(behavior, attemptCounter: 1, scheduler: scheduler, shouldRetry: shouldRetry)
	}
	
	internal func retry(behavior: RepeatBehavior, attemptCounter: UInt = 0, scheduler : SchedulerType = MainScheduler.instance, shouldRetry : RepeatPredicate? = nil)
		-> Observable<E> {
			guard attemptCounter > 0 else { return Observable.empty() }

			var delay: Double!
			let maxAttemptCount: UInt!
			
			switch behavior {
			case .Immediate(let max):
				maxAttemptCount = max
				delay = 0
			case .Delayed(let max, let time):
				maxAttemptCount = max
				delay = time
			case .ExponentialDelayed(let max, let initial, let multiplier):
				maxAttemptCount = max
				// if it's first attempt, simply use initial delay, otherwise calculate delay
				delay = attemptCounter == 1 ? initial : initial * pow(1 + multiplier, Double(attemptCounter))
			case .CustomTimerDelayed(let max, let delayCalculator):
				maxAttemptCount = max
				delay = delayCalculator(attemptCounter)
			}
			
			return catchError { error -> Observable<E> in
				guard maxAttemptCount > attemptCounter else { return Observable.error(error) }
				if let shouldRetry = shouldRetry where !shouldRetry(error) {
					return Observable.error(error)
				}
				
				if delay > 0 {
					return self.delaySubscription(delay, scheduler: scheduler).retry(behavior, attemptCounter: attemptCounter + 1, scheduler: scheduler, shouldRetry: shouldRetry)
				}
				
				return self.retry(behavior, attemptCounter: attemptCounter + 1, scheduler: scheduler, shouldRetry: shouldRetry)
			}
	}
}