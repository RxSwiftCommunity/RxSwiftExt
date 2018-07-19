//
//  driveMany+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Matthew Crenshaw on 7/19/18.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import RxSwift
import RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    /**
     Creates new shared subscriptions and sends elements to collection of observers.
     This method can be only called from `MainThread`.

     - parameter to: Collection of observers that receives events.
     - returns: Disposable object that can be used to unsubscribe the observers.
     */
    func drive<O: ObserverType>(_ observers: [O]) -> Disposable where Self.E == O.E {
        let disposables = observers.map(self.drive(_:))
        return CompositeDisposable(disposables: disposables)
    }

    /**
     Creates new shared subscriptions and sends elements to collection of observers.
     This method can be only called from `MainThread`.

     - parameter to: Collection of observers that receives events.
     - returns: Disposable object that can be used to unsubscribe the observers.
     */
    func drive<O: ObserverType>(_ observers: O...) -> Disposable where Self.E == O.E {
        return drive(observers)
    }
}
