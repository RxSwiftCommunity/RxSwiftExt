//
//  enumerated.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 12.05.18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /**
     Converts an Observable into another Observable that also emits the index count of the emission.

     - returns: An enumerated Observable.
     */
    public func enumerated() -> Observable<(index: Int, element: E)> {
        let initial: (index: Int, element: E?) = (-1, nil)
        return scan(initial) { accumulator, element in
            return (accumulator.index + 1, element)
            }
            .map { index, element in
                return (index: index, element: element!)
            }
    }
}
