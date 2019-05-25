//
//  skipLast.swift
//  RxSwiftExt
//
//  Created by Anton Nazarov on 25/05/2019.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType {
    /**
     Suppress the specified number of items emitted by an Observable
     - seealso: [skipLast operator on http://reactivex.io/documentation/operators/skiplast.html)
     - parameter count: number of items to drop from the end of the source sequence

     - returns: Returns an Observable that drops a specified number of items from the end of the source sequence.
     */
    public func skipLast(_ count: Int = 1) -> Observable<Element> {
        let cacheSize = count + 1
        return self
            .scan([]) { cache, next -> [Element] in
                (cache + [next]).suffix(cacheSize)
            }
            .filter { $0.count >= cacheSize }
            .map { $0.first! }
    }
}
