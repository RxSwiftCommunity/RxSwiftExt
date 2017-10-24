//
//  and.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 19.10.17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

extension Observable where E == Bool {

   func and(_ right: Observable<Bool>) -> Observable<Bool> {
        return Observable.combineLatest(self, right) { $0 && $1 }
    }

    public static func and<O1: Observable<Bool>, O2: Observable<Bool>, O3: Observable<Bool>>(_ source1: O1, _ source2: O2, _ source3: O3)
        -> Observable<Bool> {
        return source1.and(source2).and(source3)
    }
    
    public static func and<O1: Observable<Bool>, O2: Observable<Bool>, O3: Observable<Bool>, O4: Observable<Bool>>(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4)
        -> Observable<Bool> {
            return source1.and(source2).and(source3).and(source4)
    }
    
    public static func and<O1: Observable<Bool>, O2: Observable<Bool>, O3: Observable<Bool>, O4: Observable<Bool>, O5: Observable<Bool>>(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5)
        -> Observable<Bool> {
            return source1.and(source2).and(source3).and(source4).and(source5)
    }
    
}
