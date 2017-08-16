//
//  fromAsync.swift
//  RxSwiftExt
//
//  Created by Vincent on 12/08/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
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
