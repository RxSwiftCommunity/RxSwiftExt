//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Thane Gill 18/04/16.
//  Copyright (c) 2016 RxSwiftCommunity https://github.com/RxSwiftCommunity
//

import Foundation
import RxSwift

extension ObservableType where E: BooleanType {
    /// Boolean not operator
    @warn_unused_result(message="http://git.io/rxs.uo")
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}
