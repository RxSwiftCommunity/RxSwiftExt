//
//  WeakTarget.swift
//  RxSwiftExtDemo
//
//  Created by Ian Keen on 17/04/2016.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

enum WeakTargetError: Error {
    case error
}
enum RxEvent {
    case next, error, completed, disposed
    init<T>(event: Event<T>) {
        switch event {
        case .next(_): self = .next
        case .error(_): self = .error
        case .completed: self = .completed
        }
    }
}

var WeakTargetReferenceCount: Int = 0

class WeakTarget<Type> {
    let listener: ([RxEvent: Int]) -> Void
    fileprivate let observable: Observable<Type>
    fileprivate var disposeBag = DisposeBag()
    fileprivate var events: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 0, .disposed: 0]
    fileprivate func updateEvents(_ event: RxEvent) {
        self.events[event] = (self.events[event] ?? 0) + 1
        self.listener(self.events)
    }
    
    init(obs: Observable<Type>, listener: @escaping ([RxEvent: Int]) -> Void) {
        WeakTargetReferenceCount += 1
        self.listener = listener
        self.observable = obs
    }
    deinit { WeakTargetReferenceCount -= 1 }
    
    //MARK: - Subscribers
    fileprivate func subscriber_on(_ event: Event<Type>) { self.updateEvents(RxEvent(event: event)) }
    fileprivate func subscriber_onNext(_ element: Type) { self.updateEvents(.next) }
    fileprivate func subscriber_onError(_ error: Error) { self.updateEvents(.error) }
    fileprivate func subscriber_onComplete() { self.updateEvents(.completed) }
    fileprivate func subscriber_onDisposed() { self.updateEvents(.disposed) }
    
    //MARK: - Subscription Setup
    func useSubscribe() {
        self.observable.subscribe(weak: self, WeakTarget.subscriber_on).disposed(by: self.disposeBag)
    }
    func useSubscribeNext() {
        //self.observable.subscribeNext(self.subscriber_onNext).addDisposableTo(self.disposeBag) //uncomment this line to create a retain cycle
        self.observable.subscribeNext(weak: self, WeakTarget.subscriber_onNext).disposed(by: self.disposeBag)
    }
    func useSubscribeError() {
        self.observable.subscribeError(weak: self, WeakTarget.subscriber_onError).disposed(by: self.disposeBag)
    }
    func useSubscribeComplete() {
        self.observable.subscribeCompleted(weak: self, WeakTarget.subscriber_onComplete).disposed(by: self.disposeBag)
    }
    func useSubscribeMulti() {
        self.observable
            .subscribe(
                weak: self,
                onNext: WeakTarget.subscriber_onNext,
                onError: WeakTarget.subscriber_onError,
                onCompleted: WeakTarget.subscriber_onComplete,
                onDisposed: WeakTarget.subscriber_onDisposed
            )
            .disposed(by: self.disposeBag)
    }
    
    func dispose() {
        self.disposeBag = DisposeBag()
    }
}
