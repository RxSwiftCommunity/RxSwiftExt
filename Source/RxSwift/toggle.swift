//
//  toggle.swift
//  RxSwiftExt-iOS
//
//  Created by Vincent on 20/02/2018.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    
    /**
     Returns an observable sequence of booleans, starting with `initial` and toggling its value
     at each `.next` event
     
     - parameter initial: the boolean value to initialize the sequence
     - returns: An observable sequence of booleans that starts with `initial` and toogles its value at each `.next` event
     */
    public func toggle(initial: Bool) -> Observable<Bool> {
        return scan(initial) { previous, _ in return !previous }.startWith(initial)
    }
}
