//
//  flatMapMany.swift
//  RxSwiftExt-iOS
//
//  Created by Yuto Akiba on 2018/11/03.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

extension ObservableType where E: Collection {

    func flatMapMany<O>(_ selector: @escaping (E.Element) throws -> O) -> Observable<[O.E]> where O: ObservableConvertibleType {
        return flatMap { collection -> Observable<[O.E]> in
            let new = try collection.map(selector)
            return Observable.from(new).merge().toArray()
        }
    }
}
