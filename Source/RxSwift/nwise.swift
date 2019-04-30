//
//  nwise.swift
//  RxSwiftExt
//
//  Created by Zsolt Váradi on 09/12/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType {
    /**
     Groups the elements of the source observable into arrays of N consecutive elements.

     The resulting observable:
     - does not emit anything until the source observable emits at least N elements;
     - emits an array for every element after that;
     - forwards any error or completed events.

     For example:

          --(1)--(2)--(3)-------(4)-------(5)------->
           |
           | nwise(3)
           v
          ------------([1,2,3])-([2,3,4])-([3,4,5])->

     - parameter n: size of the groups, must be greater than 1
    */
    public func nwise(_ n: Int) -> Observable<[Element]> {
        assert(n > 1, "n must be greater than 1")
        return self
            .scan([]) { acc, item in Array((acc + [item]).suffix(n)) }
            .filter { $0.count == n }
    }

    /**
     Groups the elements of the source observable into tuples of the previous and current elements.

     The resulting observable:
     - does not emit anything until the source observable emits at least 2 elements;
     - emits a tuple for every element after that, consisting of the previous and the current item;
     - forwards any error or completed events.

     For example:

         --(1)--(2)--(3)-------(4)-------(5)------->
          |
          | pairwise()
          v
         -------(1,2)-(2,3)----(3,4)-----(4,5)----->
    */
    public func pairwise() -> Observable<(Element, Element)> {
        return self.nwise(2)
            .map { ($0[0], $0[1]) }
    }
}
