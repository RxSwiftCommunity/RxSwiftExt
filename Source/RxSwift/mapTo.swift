//
//  mapTo.swift
//  RxSwiftExtDemo
//
//  Created by Marin Todorov on 4/12/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
	
	/**
	Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
	
	- parameter value: A constant that each element of the input sequence is being replaced with
	- returns: An observable sequence containing the values `value` provided as a parameter
	*/
	
	public func mapTo<R>(_ value: R) -> Observable<R> {
		return map {_ in value}
	}
}
