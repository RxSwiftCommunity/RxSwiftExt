//
//  nonPollingBuffer.swift
//  RxSwiftExt
//
//  Created by Brian Semiglia on 07/31/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {

    /**
     Projects each element of an observable sequence into a buffer that's sent out when a given amount of time has elapsed since the first event after the last flush.
     
     This is similar to the standard buffer except that events are not produced as the result of a polling timer.
     */
    public func nonPollingBuffer(timeSpan: RxTimeInterval, capacity: Int, scheduler: SchedulerType) -> Observable<[E]> { return
        scan(
            Delayed(
                due: Date() + timeSpan,
                value: [E]()
            )
        ) { sum, x in
            switch Delay.updated(sum, x: x, span: timeSpan, capacity: capacity) {
            case .none:
                return Delayed(
                    due: Date(),
                    value: sum.value + [x]
                )
            case .reset:
                return Delayed(
                    due: Date() + timeSpan,
                    value: [x]
                )
            case .offset:
                return Delayed(
                    due: sum.due,
                    value: sum.value + [x]
                )
            }
            }
            .flatMapLatest {
                Observable
                    .just($0.value)
                    .delay(
                        $0.due.timeIntervalSince(Date()) > 0
                            ? $0.due.timeIntervalSince(Date())
                            : 0
                        ,
                        scheduler: scheduler
                    )
            }
    }
}

private struct Delayed<T> {
    let due: Date
    let value: [T]
}

private enum Delay {

    case none
    case reset
    case offset

    static func updated<T>(_ input: Delayed<T>, x: T, span: RxTimeInterval, capacity: Int) -> Delay {
        if (input.value + [x]).count == capacity {
            return .none
        } else if Date() > input.due {
            return .reset
        } else {
            return .offset
        }
    }
}
