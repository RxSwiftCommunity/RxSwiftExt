//
//  fromAsync.swift
//  RxSwiftExt
//
//  Created by Vincent on 12/08/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {

    /**
     Transforms an async function that returns data through a completionHandler in a function that returns data through an Observable
     - The returned function will thake the same arguments than asyncRequest, minus the last one
     */
    public static func fromAsync(_ asyncRequest: @escaping (@escaping (Element) -> Void) -> Void) -> Observable<Element> {
        return Observable.create({ (o) -> Disposable in
            asyncRequest({ (result) in
                o.onNext(result)
                o.onCompleted()
            })

            return Disposables.create()
        })
    }

    public static func fromAsync<A>(_ asyncRequest: @escaping (A, @escaping (Element) -> Void) -> Void) -> (A) -> Observable<Element> {
        return { (a: A) in Observable.fromAsync(curry(asyncRequest)(a)) }
    }

    public static func fromAsync<A, B>(_ asyncRequest: @escaping (A, B, @escaping (Element) -> Void) -> Void) -> (A, B) -> Observable<Element> {
        return { (a: A, b: B) in Observable.fromAsync(curry(asyncRequest)(a)(b)) }
    }

    public static func fromAsync<A, B, C>(_ asyncRequest: @escaping (A, B, C, @escaping (Element) -> Void) -> Void) -> (A, B, C) -> Observable<Element> {
        return { (a: A, b: B, c: C) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)) }
    }

    public static func fromAsync<A, B, C, D>(_ asyncRequest: @escaping (A, B, C, D, @escaping (Element) -> Void) -> Void) -> (A, B, C, D) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)) }
    }

    public static func fromAsync<A, B, C, D, E>(_ asyncRequest: @escaping (A, B, C, D, E, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)) }
    }

    public static func fromAsync<A, B, C, D, E, F>(_ asyncRequest: @escaping (A, B, C, D, E, F, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E, F) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)) }
    }

    public static func fromAsync<A, B, C, D, E, F, G>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E, F, G) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)) }
    }

    public static func fromAsync<A, B, C, D, E, F, G, H>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E, F, G, H) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)) }
    }

    public static func fromAsync<A, B, C, D, E, F, G, H, I>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, I, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E, F, G, H, I) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H, i: I) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)(i)) }
    }

    public static func fromAsync<A, B, C, D, E, F, G, H, I, J>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, I, J, @escaping (Element) -> Void) -> Void) -> (A, B, C, D, E, F, G, H, I, J) -> Observable<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H, i: I, j: J) in Observable.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)) }
    }
}

public enum FromAsyncError: Error {
    /// Both result & error can't be nil
    case inconsistentCompletionResult
}

public extension PrimitiveSequenceType where Trait == SingleTrait {
    /**
     Transforms an async function that returns data or error through a completionHandler in a function that returns data through a Single
     - The returned function will thake the same arguments than asyncRequest, minus the last one
     */
    static func fromAsync<Er: Error>(_ asyncRequest: @escaping (@escaping (Element?, Er?) -> Void) -> Void) -> Single<Element> {
        return .create { single in
            asyncRequest { result, error in
                switch (result, error) {
                case let (.some(result), nil):
                    single(.success(result))
                case let (nil, .some(error)):
                    single(.error(error))
                default:
                    single(.error(FromAsyncError.inconsistentCompletionResult))
                }
            }
            return Disposables.create()
        }
    }

    static func fromAsync<A, Er: Error>(_ asyncRequest: @escaping (A, @escaping (Element?, Er?) -> Void) -> Void) -> (A) -> Single<Element> {
        return { (a: A) in Single.fromAsync(curry(asyncRequest)(a)) }
    }

    static func fromAsync<A, B, Er: Error>(_ asyncRequest: @escaping (A, B, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B) -> Single<Element> {
        return { (a: A, b: B) in Single.fromAsync(curry(asyncRequest)(a)(b)) }
    }

    static func fromAsync<A, B, C, Er: Error>(_ asyncRequest: @escaping (A, B, C, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C) -> Single<Element> {
        return { (a: A, b: B, c: C) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)) }
    }

    static func fromAsync<A, B, C, D, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)) }
    }

    static func fromAsync<A, B, C, D, E, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)) }
    }

    static func fromAsync<A, B, C, D, E, F, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, F, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E, F) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)) }
    }

    static func fromAsync<A, B, C, D, E, F, G, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E, F, G) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)) }
    }

    static func fromAsync<A, B, C, D, E, F, G, H, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E, F, G, H) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)) }
    }

    static func fromAsync<A, B, C, D, E, F, G, H, I, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, I, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E, F, G, H, I) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H, i: I) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)(i)) }
    }

    static func fromAsync<A, B, C, D, E, F, G, H, I, J, Er: Error>(_ asyncRequest: @escaping (A, B, C, D, E, F, G, H, I, J, @escaping (Element?, Er?) -> Void) -> Void) -> (A, B, C, D, E, F, G, H, I, J) -> Single<Element> {
        return { (a: A, b: B, c: C, d: D, e: E, f: F, g: G, h: H, i: I, j: J) in Single.fromAsync(curry(asyncRequest)(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)) }
    }
}
