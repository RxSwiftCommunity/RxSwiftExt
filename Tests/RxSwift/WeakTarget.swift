//
//  WeakTarget.swift
//  RxSwiftExt
//
//  Created by Ian Keen on 17/04/2016.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum WeakTargetError: Error {
    case error
}
enum RxEvent {
    case next, error, completed, disposed
    init<T>(event: Event<T>) {
        switch event {
        case .next: self = .next
        case .error: self = .error
        case .completed: self = .completed
        }
    }
}

private var weakTargetReferenceCounts: [ObjectIdentifier: Int] = [:]

private func mutateReferenceCount<T>(for type: T.Type, mutator: (Int) -> Int) {
     weakTargetReferenceCounts[ObjectIdentifier(type)] = mutator(weakTargetReferenceCounts[ObjectIdentifier(type)] ?? 0)
}

private func incReferenceCount<T>(for type: T.Type) {
    mutateReferenceCount(for: type) {
        return $0 + 1
    }
}

private func decReferenceCount<T>(for type: T.Type) {
    mutateReferenceCount(for: type) {
        return $0 - 1
    }
}

func resetReferenceCount<T>(for type: T.Type) {
    mutateReferenceCount(for: type) { _ in
        return 0
    }
}

func getReferenceCount<T>(for type: T.Type) -> Int {
    return weakTargetReferenceCounts[ObjectIdentifier(type)] ?? 0
}

class WeakTarget<Type, Sequence> {
    let listener: ([RxEvent: Int]) -> Void
    fileprivate let sequence: Sequence
    fileprivate var disposeBag = DisposeBag()
    fileprivate var events: [RxEvent: Int] = [.next: 0, .error: 0, .completed: 0, .disposed: 0]
    fileprivate func updateEvents(_ event: RxEvent) {
        self.events[event] = (self.events[event] ?? 0) + 1
        self.listener(self.events)
    }

    init(sequence: Sequence, listener: @escaping ([RxEvent: Int]) -> Void) {
        incReferenceCount(for: WeakTarget.self)
        self.listener = listener
        self.sequence = sequence
    }

    deinit { decReferenceCount(for: WeakTarget.self) }

    // MARK: - Subscribers
    fileprivate func subscriber_on(_ event: Event<Type>) { self.updateEvents(RxEvent(event: event)) }
    fileprivate func subscriber_onNext(_ element: Type) { self.updateEvents(.next) }
    fileprivate func subscriber_onError(_ error: Error) { self.updateEvents(.error) }
    fileprivate func subscriber_onCompleted() { self.updateEvents(.completed) }
    fileprivate func subscriber_onDisposed() { self.updateEvents(.disposed) }

    func dispose() {
        self.disposeBag = DisposeBag()
    }
}

// MARK: - Observable Subscription Setup
extension WeakTarget where Sequence == Observable<Type> {
    func useSubscribe() {
        self.sequence
            .subscribe(weak: self, WeakTarget.subscriber_on)
            .disposed(by: self.disposeBag)
    }

    func useSubscribeNext() {
//        // uncomment these lines to create a retain cycle
//        self.sequence
//            .subscribe(onNext: self.subscriber_onNext)
//            .disposed(by: self.disposeBag)
        self.sequence
            .subscribeNext(weak: self, WeakTarget.subscriber_onNext)
            .disposed(by: self.disposeBag)
    }

    func useSubscribeError() {
        self.sequence
            .subscribeError(weak: self, WeakTarget.subscriber_onError)
            .disposed(by: self.disposeBag)
    }

    func useSubscribeCompleted() {
        self.sequence
            .subscribeCompleted(weak: self, WeakTarget.subscriber_onCompleted)
            .disposed(by: self.disposeBag)
    }

    func useSubscribeMulti() {
        self.sequence
            .subscribe(
                weak: self,
                onNext: WeakTarget.subscriber_onNext,
                onError: WeakTarget.subscriber_onError,
                onCompleted: WeakTarget.subscriber_onCompleted,
                onDisposed: WeakTarget.subscriber_onDisposed
            )
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Driver Subscription Setup
extension WeakTarget where Sequence == Driver<Type> {
    func useDriveMulti(retaining: Bool = false) {
        if retaining {
            self.sequence
                .drive(
                    onNext: self.subscriber_onNext,
                    onCompleted: self.subscriber_onCompleted,
                    onDisposed: self.subscriber_onDisposed
                )
                .disposed(by: self.disposeBag)
        } else {
            self.sequence
                .drive(
                    weak: self,
                    onNext: WeakTarget.subscriber_onNext,
                    onCompleted: WeakTarget.subscriber_onCompleted,
                    onDisposed: WeakTarget.subscriber_onDisposed
                )
                .disposed(by: self.disposeBag)
        }
    }
}

// MARK: - Signal Subscription Setup
extension WeakTarget where Sequence == Signal<Type> {
    func useEmitMulti(retaining: Bool = false) {
        if retaining {
            self.sequence
                .emit(
                    onNext: self.subscriber_onNext,
                    onCompleted: self.subscriber_onCompleted,
                    onDisposed: self.subscriber_onDisposed
                )
                .disposed(by: self.disposeBag)
        } else {
            self.sequence
                .emit(
                    weak: self,
                    onNext: WeakTarget.subscriber_onNext,
                    onCompleted: WeakTarget.subscriber_onCompleted,
                    onDisposed: WeakTarget.subscriber_onDisposed
                )
                .disposed(by: self.disposeBag)
        }
    }
}
