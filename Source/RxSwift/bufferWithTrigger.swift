//
//  bufferWithTrigger.swift
//  RxSwiftExt
//
//  Created by Patrick Maltagliati on 11/12/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    /**
     Collects the elements of the source observable, and emits them as an array when the trigger emits.

     - parameter trigger: The observable sequence used to signal the emission of the buffered items.
     - returns: The buffered observable from elements of the source sequence.
     */
    public func bufferWithTrigger<Trigger: ObservableType>(_ trigger: Trigger) -> Observable<[Element]> {
        return Observable.create { observer in
            var buffer: [Element] = []
            let lock = NSRecursiveLock()
            let triggerDisposable = trigger.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next:
                    observer.onNext(buffer)
                    buffer = []
                default:
                    break
                }
            }
            let disposable = self.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let element):
                    buffer.append(element)
                case .completed:
                    observer.onNext(buffer)
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                    buffer = []
                }
            }
            return Disposables.create([disposable, triggerDisposable])
        }
    }
}
