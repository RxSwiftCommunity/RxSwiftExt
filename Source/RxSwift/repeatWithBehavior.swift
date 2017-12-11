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
	internal func repeatWithBehavior(_ defaultRepeat: UInt, behavior: RepeatBehavior, scheduler : SchedulerType = MainScheduler.instance, shouldRepeat : RepeatPredicate? = nil)
		-> Observable<E> {
            let repeatObserver = PublishSubject<UInt>()
            return repeatObserver.startWith(defaultRepeat)
                .flatMapLatest { currentRepeat -> Observable<E> in
                    // calculate conditions for bahavior
                    let conditions = behavior.calculateConditions(currentRepeat)
                    
                    //repeat
                    guard conditions.maxCount > currentRepeat else { return Observable.empty() }
                    
                    if let shouldRepeat = shouldRepeat , !shouldRepeat() {
                        // also return error if predicate says so
                        return Observable.empty()
                    }
                    var observable: Observable<E> = self.asObservable() // if there is no delay, simply retry
                    if conditions.delay > 0.0 && currentRepeat > defaultRepeat {
                        // otherwise retry after specified delay
                        observable = observable.delaySubscription(conditions.delay, scheduler: scheduler)
                    }
                    return observable.do(onCompleted: {
                        DispatchQueue.main.async {
                            repeatObserver.onNext(currentRepeat + 1)
                        }
                    })
                }
	}
}
