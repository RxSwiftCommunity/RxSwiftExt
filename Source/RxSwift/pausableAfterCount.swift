//
//  pausableAfterCount.swift
//  RxSwiftExt
//
//  Created by Tanguy Helesbeux on 24/05/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {

    /**
     Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.

     The pause is available only after a certain count of events. Before the number of emitted events reaches that count
     the Pauser will not be taken care of. When the Pauser is active, elements are ignored unless the second sequence
     has most recently emitted `true`.

     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)

     - Parameter count: the number of events before considering the pauser parameter
     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - returns: The observable sequence which is paused based upon the pauser observable sequence.
     */
    public func pausable<P: ObservableType> (afterCount count: Int, withPauser pauser: P) -> Observable<E> where P.E == Bool {

        return Observable<E>.create { observer in

            let lock = NSRecursiveLock()
            var paused = true
            var elementIndex = 0

            let pauserDisposable = pauser.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let resume):
                    paused = !resume
                case .completed:
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }

            let disposable = self.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let element):

                    if elementIndex < count {
                        elementIndex += 1
                        observer.onNext(element)
                    } else if !paused {
                        observer.onNext(element)
                    }

                case .completed:
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create([disposable, pauserDisposable])
        }
    }
}
