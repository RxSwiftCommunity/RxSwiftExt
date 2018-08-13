//
//  RxCocoa.swift
//  RxSwiftExt-iOS
//
//  Created by Vladimir Kushelkov on 13/08/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxCocoa

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

#if os(iOS) || os(tvOS)
func castToPointerOrThrow<T>(_ pointeeType: T.Type, _ object: Any) throws -> UnsafeMutablePointer<T> {
    let value = try castOrThrow(NSValue.self, object)
    guard let rawPointer = value.pointerValue else { throw RxCocoaError.unknown }
    return rawPointer.bindMemory(to: T.self, capacity: MemoryLayout<T>.size)
}
#endif
