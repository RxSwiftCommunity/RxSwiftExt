//
//  pausableBuffered.swift
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
     
     While paused, elements from the source are buffered, limited to a maximum number of element.
     
     When resumed, all bufered elements are flushed as single events in a contiguous stream.
     
     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)
     
     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - parameter limit: The maximum number of element buffered. Pass `nil` to buffer all elements without limit. Default 1.
     - parameter flushOnCompleted: If `true` bufered elements will be flushed when the source completes. Default `true`.
     - parameter flushOnError: If `true` bufered elements will be flushed when the source errors. Default `true`.
     - returns: The observable sequence which is paused and resumed based upon the pauser observable sequence.
     */
    public func pausableBuffered<P: ObservableType> (_ pauser: P, limit: Int? = 1, flushOnCompleted: Bool = true, flushOnError: Bool = true) -> Observable<E> where P.E == Bool {

        return Observable<E>.create { observer in
            var buffer: [E] = []
            if let limit = limit {
                buffer.reserveCapacity(limit)
            }

            var paused = true
            let lock = NSRecursiveLock()

            let flush = {
                for value in buffer {
                    observer.onNext(value)
                }
                buffer.removeAll(keepingCapacity: limit != nil)
            }

            let boundaryDisposable = pauser.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let resume):
                    paused = !resume

                    if resume && buffer.count > 0 {
                        flush()
                    }
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
                    if paused {
                        buffer.append(element)
                        if let limit = limit, buffer.count > limit {
                            buffer.remove(at: 0)
                        }
                    } else {
                        observer.onNext(element)
                    }

                case .completed:
                    if flushOnCompleted { flush() }
                    observer.onCompleted()

                case .error(let error):
                    if flushOnError { flush() }
                    observer.onError(error)
                }
            }

            return Disposables.create([disposable, boundaryDisposable])
        }
    }

}
