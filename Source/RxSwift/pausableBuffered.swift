//
//  pausableBuffered.swift
//  RxSwiftExt
//
//  Created by Tanguy Helesbeux on 24/05/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    /**
     Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.
     
     When the pause ends, replays the last element from the source observable.
     
     Elements are ignored unless the second sequence has most recently emitted `true`.
     
     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)
     
     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - returns: The observable sequence which is paused based upon the pauser observable sequence.
     */
    
public func pausableBuffered<P : ObservableType> (_ pauser: P) -> Observable<E> where P.E == Bool {
    
    return Observable<E>.create { observer in
        var latest: E? = nil
        var paused = true
        var completeCount = 0
        let lock = NSRecursiveLock()
        
        let boundaryDisposable =
            pauser
                .distinctUntilChanged()
                .subscribe { event in
                    lock.lock(); defer { lock.unlock() }
                    switch event {
                    case .next(let resume):
                        paused = !resume
                        
                        if resume {
                            if let el = latest {
                                observer.onNext(el)
                                latest = nil
                            }
                        }
                    case .error(let error):
                        observer.onError(error)
                    default:
                        break
                    }
        }
        
        let disposable = self.subscribe { event in
            lock.lock(); defer { lock.unlock() }
            switch event {
            case .next(let element):
                if paused {
                    latest = element
                } else {
                    observer.onNext(element)
                }
            case .completed:
                observer.onCompleted()
            case .error(let error):
                observer.onError(error)
            }
        }
        
        return Disposables.create([disposable, boundaryDisposable])
    }
    
}
    
}

