//
//  addTests.swift
//  RxSwiftExt
//
//  Created by Joan Disho on 25.10.17.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class addTests: XCTestCase {

	var flag = Observable.just(true)
	var flags = [Observable.just(false), Observable.just(true), Observable.just(true), Observable.just(false)]
	var observer: TestableObserver<Bool>!

	override func setUp() {
		super.setUp()

		let scheduler = TestScheduler(initialClock: 0)
		observer = scheduler.createObserver(Bool.self)

		_ = flag.and(flags).subscribe(observer)
		_ = flag.and(flags[1], flags[2]).subscribe(observer)

		scheduler.start()
	}

	func testReplaceWithResultCount() {
		XCTAssertEqual(observer.events.count, 4)
	}

	func testReplaceWithResultValues() {
		let correctValues = [next(0, false), completed(0), next(0, true), completed(0)]
		XCTAssertEqual(observer.events, correctValues)
	}
}
