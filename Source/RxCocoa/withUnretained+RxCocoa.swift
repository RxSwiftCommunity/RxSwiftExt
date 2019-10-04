//
//  withUnretained+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Shai Mishali on 04/10/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import RxSwift
import RxCocoa

extension SharedSequence {
    /**
     Provides an unretained, safe to use (i.e. not implicitly unwrapped), reference to an object along with the events emitted by the shared sequence.
     In the case the provided object cannot be retained successfully, the seqeunce will with an error.

     - parameter obj: The object to provide an unretained reference on.
     - parameter resultSelector: A function to combine the unretained referenced on `obj` and the value of the observable sequence.
     - returns: A shared sequence that contains the result of `resultSelector` being called with an unretained reference on `obj` and the values of the original sequence.
     */
    public func withUnretained<Object: AnyObject, Out>(_ obj: Object,
                                                       resultSelector: @escaping ((Object, Element)) -> Out)
        -> SharedSequence<SharingStrategy, Out> {
        asObservable()
            .map { [weak obj] element -> Out in
                guard let obj = obj else { throw UnretainedError.failedRetaining }

                return resultSelector((obj, element))
            }
            .asSharedSequence(onErrorDriveWith: .empty())
    }

    /**
     Provides an unretained, safe to use (i.e. not implicitly unwrapped), reference to an object along with the events emitted by the sequence.
     In the case the provided object cannot be retained successfully, the seqeunce will complete.

     - parameter obj: The object to provide an unretained reference on.
     - returns: A shjared sequence of tuples that contains both an unretained reference on `obj` and the values of the original sequence.
     */
    public func withUnretained<Object: AnyObject>(_ obj: Object) -> SharedSequence<SharingStrategy, (Object, Element)> {
        withUnretained(obj) { ($0, $1) }
    }
}
