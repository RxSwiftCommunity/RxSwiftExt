//
//  bindCollection+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Matthew Crenshaw on 7/16/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift

public extension ObservableType {
    /**
     Creates new shared subscriptions and sends elements to collection of observers.

     - parameter to: Collection of observers that receives events.
     - returns: Disposable object that can be used to unsubscribe the observers.
     */
    func bind<O>(to observers: [O]) -> Disposable where O: ObserverType, Self.E == O.E {
        let shared = self.share()
        let disposables = observers.map(shared.bind(to:))
        return CompositeDisposable(disposables: disposables)
    }
}
