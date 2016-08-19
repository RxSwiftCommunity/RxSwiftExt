//
//  WeakTarget.swift
//  RxSwiftExtDemo
//
//  Created by Ian Keen on 17/04/2016.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

enum WeakTargetError: ErrorType {
    case Error
}
enum RxEvent {
    case Next, Error, Completed, Disposed
    init<T>(event: Event<T>) {
        switch event {
        case .Next(_): self = .Next
        case .Error(_): self = .Error
        case .Completed: self = .Completed
        }
    }
}

var WeakTargetReferenceCount: Int = 0

class WeakTarget<Type> {
    let listener: ([RxEvent: Int]) -> Void
    private let observable: Observable<Type>
    private var disposeBag = DisposeBag()
    private var events: [RxEvent: Int] = [.Next: 0, .Error: 0, .Completed: 0, .Disposed: 0]
    private func updateEvents(event: RxEvent) {
        self.events[event] = (self.events[event] ?? 0) + 1
        self.listener(self.events)
    }
    
    init(obs: Observable<Type>, listener: ([RxEvent: Int]) -> Void) {
        WeakTargetReferenceCount += 1
        self.listener = listener
        self.observable = obs
    }
    deinit { WeakTargetReferenceCount -= 1 }
    
    //MARK: - Subscribers
    private func subscriber_on(event: Event<Type>) { self.updateEvents(RxEvent(event: event)) }
    private func subscriber_onNext(element: Type) { self.updateEvents(.Next) }
    private func subscriber_onError(error: ErrorType) { self.updateEvents(.Error) }
    private func subscriber_onComplete() { self.updateEvents(.Completed) }
    private func subscriber_onDisposed() { self.updateEvents(.Disposed) }
    
    //MARK: - Subscription Setup
    func useSubscribe() {
        self.observable.subscribe(weak: self, WeakTarget.subscriber_on).addDisposableTo(self.disposeBag)
    }
    func useSubscribeNext() {
        //self.observable.subscribeNext(self.subscriber_onNext).addDisposableTo(self.disposeBag) //uncomment this line to create a retain cycle
        self.observable.subscribeNext(weak: self, WeakTarget.subscriber_onNext).addDisposableTo(self.disposeBag)
    }
    func useSubscribeError() {
        self.observable.subscribeError(weak: self, WeakTarget.subscriber_onError).addDisposableTo(self.disposeBag)
    }
    func useSubscribeComplete() {
        self.observable.subscribeCompleted(weak: self, WeakTarget.subscriber_onComplete).addDisposableTo(self.disposeBag)
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
            .addDisposableTo(self.disposeBag)
    }
    
    func dispose() {
        self.disposeBag = DisposeBag()
    }
}