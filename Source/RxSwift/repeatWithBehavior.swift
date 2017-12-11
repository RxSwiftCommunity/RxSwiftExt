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
 Uses RepeatBehavior defined in retryWithBehavior
*/

/** Dummy error to use with catchError to restart the observable */
private enum RepeatError: Error {
    case catchable
}

extension ObservableType {

    /**
	Repeats the source observable sequence using given behavior when it completes
	- parameter behavior: Behavior that will be used when the observable completes
	- parameter scheduler: Schedular that will be used for delaying subscription after error
	- parameter shouldRepeat: Custom optional closure for decided whether the observable should repeat another round
	- returns: Observable sequence that will be automatically repeat when it completes
	*/
	public func repeatWithBehavior(_ behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRepeat : RepeatPredicate? = nil) -> Observable<E> {
		return repeatWithBehavior(0, behavior: behavior, scheduler: scheduler, shouldRepeat: shouldRepeat)
	}
	
	/**
	Repeats the source observable sequence using given behavior when it completes
	- parameter currentRepeat: Number of the current repetition
	- parameter behavior: Behavior that will be used in case of completion
	- parameter scheduler: Schedular that will be used for delaying subscription after error
	- parameter shouldRepeat: Custom optional closure for decided whether the observable should repeat another round
	- returns: Observable sequence that will be automatically repeat when it completes
	*/
	internal func repeatWithBehavior(_ currentRepeat: UInt, behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRepeat : RepeatPredicate? = nil)
		-> Observable<E> {
            return Observable.create { observer in
                let defaultRepeat: UInt = 0
                let repeatObserver = BehaviorSubject<UInt>(value: currentRepeat)
                let observable = repeatObserver
                    .flatMapLatest { currentRepeat -> Observable<(UInt, Event<E>)> in
                        var observable: Observable<E> = self.asObservable() // if there is no delay, simply retry

                        if currentRepeat != defaultRepeat {
                            // calculate conditions for bahavior
                            let conditions = behavior.calculateConditions(currentRepeat)
                            
                            //repeat
                            guard conditions.maxCount > currentRepeat else { return Observable.error(RepeatError.catchable) }
                            
                            if let shouldRepeat = shouldRepeat , !shouldRepeat() {
                                // also return error if predicate says so
                                return Observable.error(RepeatError.catchable)
                            }
                            if conditions.delay > 0.0 {
                                // otherwise retry after specified delay
                                observable = observable.delaySubscription(conditions.delay, scheduler: scheduler)
                            }
                        }
                        return observable.materialize().map { (currentRepeat, $0) }
                }
                return observable.subscribe { event in
                    switch event {
                    case .next(let result):
                        switch result.1 {
                        case .completed:
                            repeatObserver.onNext(result.0 + 1) // repeat on completed
                        default:
                            observer.on(result.1) // send event
                        }
                    case .error:
                        return observer.onCompleted() // complete
                    default:
                        break
                    }
                }
            }
	}
}
