//
//  mergeWith.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 12/05/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /**
     Merges elements from the observable sequence with those of a different observable sequence into a single observable sequence.

     - parameter with: Other observable.
     - returns: The observable sequence that merges the elements of the observable sequences.
     */
    public func merge(with other: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self, other)
    }

    /**
     Merges elements from the observable sequence with those of a different observable sequences into a single observable sequence.

     - parameter with: Other observables.
     - returns: The observable sequence that merges the elements of the observable sequences.
     */
    public func merge(with others: [Observable<Element>]) -> Observable<Element> {
        return Observable.merge([self] + others)
    }
}
