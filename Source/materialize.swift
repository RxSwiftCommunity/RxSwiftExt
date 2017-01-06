//
//  materialize.swift
//  RxSwiftExt
//
//  Created by Andy Chou on 1/5/17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    /**
     Convert any Observable into an Observable of its events.

     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)

     - returns: An observable sequence that wraps events in an Event<E>. The returned Observable never errors, but it does complete after observing all of the events of the underlying Observable.
     */
    public func materialize() -> Observable<Event<E>> {
        return Observable.create { observer in
            return self.subscribe { event in
                observer.onNext(event)
                if event.isStopEvent {
                    observer.onCompleted()
                }
            }
        }
    }
}

/**
 A type that expresses convertibility into an RxSwift Event<E>.
 This is used mainly for the implementation of the dematerialize operator.
 */
public protocol EventConvertibleType {
    associatedtype E
    func asEvent() -> Event<E>
}

extension Event : EventConvertibleType {
    public typealias E = Element
    public func asEvent() -> Event<E> { return self }
}

extension ObservableType where E: EventConvertibleType {
    /**
     Convert an Observable<Event<E>> into an Observable<E> of the Event elements.

     - seealso: [materialize operator on reactivex.io](http://reactivex.io/documentation/operators/materialize-dematerialize.html)

     - returns: An observable sequence that unwraps the Events of the underlying observable.
     */
    public func dematerialize() -> Observable<E.E> {
        return Observable.create { observer in
            return self.subscribe(onNext: { event in
                switch event.asEvent() {
                case .next(let element): observer.onNext(element)
                case .error(let error): observer.onError(error)
                case .completed: observer.onCompleted()
                }
            })
        }
    }

    /// Return only the error events of an Observable<Event<E>>
    public func errors() -> Observable<Error> {
        return self.filter { $0.asEvent().error != nil }
            .map { $0.asEvent().error! }
    }

    /// Return only the onNext element events of an Observable<Event<E>>
    public func elements() -> Observable<E.E> {
        return self.filter { $0.asEvent().element != nil }
            .map { $0.asEvent().element! }
    }
}
