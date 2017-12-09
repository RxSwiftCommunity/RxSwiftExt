//
//  nwise.swift
//  RxSwiftExt
//
//  Created by Zsolt Váradi on 2017. 12. 09..
//  Copyright © 2017. RxSwiftCommunity. All rights reserved.
//

import RxSwift

extension ObservableType {
    /**
     Groups the elements of the source observable into arrays of N consecutive elements.

     The resulting observable:
     - does not emit anything until the source emits at least N elements;
     - emits an array for every element after that;
     - and forwards any error or completed event.

     For example:

          --(1)--(2)--(3)-------(4)-------(5)------->
           |
           | nwise(3)
           v
          ------------([1,2,3])-([2,3,4])-([3,4,5])->

     Caveat: n = 0 causes the operator to collapse into: `.map { _ in [] }`.

     - parameter n: size of the groups
    */
    public func nwise(_ n: UInt) -> Observable<[E]> {
        return self
            .scan([]) { acc, item in
                // UInt->Int conversion is used to enforce a non-negative parameter at build time.
                // Supplying a negative number to nwise would cause a fatal error at runtime.
                Array((acc + [item]).suffix(Int(n)))
            }
            .filter { $0.count == n }
    }

    /**
     Groups the elements of the source observable into tuples of the last and the previous elements.

     The resulting observable:
     - does not emit anything until the source emits at least 2 elements;
     - emits a tuple for every element after that;
     - and forwards any error or completed event.

     For example:

         --(1)--(2)--(3)-------(4)-------(5)------->
          |
          | pairwise()
          v
         -------(1,2)-(2,3)----(3,4)-----(4,5)----->
    */
    public func pairwise() -> Observable<(E, E)> {
        return self.nwise(2)
            .map { ($0[0], $0[1]) }
    }
}
