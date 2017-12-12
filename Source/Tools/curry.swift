//
//  curry.swift
//  RxSwiftExt
//
//  Created by Vincent on 12/08/2017.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import Foundation

internal func curry<A, B>(_ function: @escaping (A) -> B) -> (A) -> B {
    return { (a: A) -> B in function(a) }
}

internal func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { (a: A) -> (B) -> C in { (b: B) -> C in function(a, b) } }
}

internal func curry<A, B, C, D>(_ function: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { (a: A) -> (B) -> (C) -> D in { (b: B) -> (C) -> D in { (c: C) -> D in function(a, b, c) } } }
}

internal func curry<A, B, C, D, E>(_ function: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    return { (a: A) -> (B) -> (C) -> (D) -> E in { (b: B) -> (C) -> (D) -> E in { (c: C) -> (D) -> E in { (d: D) -> E in function(a, b, c, d) } } } }
}

internal func curry<A, B, C, D, E, F>(_ function: @escaping (A, B, C, D, E) -> F) -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> F in { (b: B) -> (C) -> (D) -> (E) -> F in { (c: C) -> (D) -> (E) -> F in { (d: D) -> (E) -> F in { (e: E) -> F in function(a, b, c, d, e) } } } } }
}

internal func curry<A, B, C, D, E, F, G>(_ function: @escaping (A, B, C, D, E, F) -> G) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G in { (b: B) -> (C) -> (D) -> (E) -> (F) -> G in { (c: C) -> (D) -> (E) -> (F) -> G in { (d: D) -> (E) -> (F) -> G in { (e: E) -> (F) -> G in { (f: F) -> G in function(a, b, c, d, e, f) } } } } } }
}

internal func curry<A, B, C, D, E, F, G, H>(_ function: @escaping (A, B, C, D, E, F, G) -> H) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in { (c: C) -> (D) -> (E) -> (F) -> (G) -> H in { (d: D) -> (E) -> (F) -> (G) -> H in { (e: E) -> (F) -> (G) -> H in { (f: F) -> (G) -> H in { (g: G) -> H in function(a, b, c, d, e, f, g) } } } } } } }
}

internal func curry<A, B, C, D, E, F, G, H, I>(_ function: @escaping (A, B, C, D, E, F, G, H) -> I) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in { (d: D) -> (E) -> (F) -> (G) -> (H) -> I in { (e: E) -> (F) -> (G) -> (H) -> I in { (f: F) -> (G) -> (H) -> I in { (g: G) -> (H) -> I in { (h: H) -> I in function(a, b, c, d, e, f, g, h) } } } } } } } }
}

internal func curry<A, B, C, D, E, F, G, H, I, J>(_ function: @escaping (A, B, C, D, E, F, G, H, I) -> J) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in { (e: E) -> (F) -> (G) -> (H) -> (I) -> J in { (f: F) -> (G) -> (H) -> (I) -> J in { (g: G) -> (H) -> (I) -> J in { (h: H) -> (I) -> J in { (i: I) -> J in function(a, b, c, d, e, f, g, h, i) } } } } } } } } }
}

internal func curry<A, B, C, D, E, F, G, H, I, J, K>(_ function: @escaping (A, B, C, D, E, F, G, H, I, J) -> K) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in { (e: E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in { (f: F) -> (G) -> (H) -> (I) -> (J) -> K in { (g: G) -> (H) -> (I) -> (J) -> K in { (h: H) -> (I) -> (J) -> K in { (i: I) -> (J) -> K in { (j: J) -> K in function(a, b, c, d, e, f, g, h, i, j) } } } } } } } } } }
}

internal func curry<A, B, C, D, E, F, G, H, I, J, K, L>(_ function: @escaping (A, B, C, D, E, F, G, H, I, J, K) -> L) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L {
    return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (e: E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (f: F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in { (g: G) -> (H) -> (I) -> (J) -> (K) -> L in { (h: H) -> (I) -> (J) -> (K) -> L in { (i: I) -> (J) -> (K) -> L in { (j: J) -> (K) -> L in { (k: K) -> L in function(a, b, c, d, e, f, g, h, i, j, k) } } } } } } } } } } }
}
