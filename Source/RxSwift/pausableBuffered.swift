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
        let pause = pausable(pauser)
        let restart = sample(pauser.ignore(false).distinctUntilChanged())
        return Observable.merge(pause, restart)
    }
    
}

