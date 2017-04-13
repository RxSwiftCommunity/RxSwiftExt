//
//  materialized+elementsTests.swift
//  RxSwiftExt
//
//  Created by Adam Borek on 12.04.2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxSwiftExt

final class materializedElementsTests: XCTestCase {
	private var testScheduler: TestScheduler!
	private var eventObservable: Observable<Event<Int>>!
	private let dummyError = NSError(domain: "dummy", code: -102)
	private var disposeBag = DisposeBag()

	override func setUp() {
		super.setUp()
		testScheduler = TestScheduler(initialClock: 0)
		eventObservable = testScheduler.createHotObservable([
				next(0, Event.next(0)),
				next(100, Event.next(1)),
				next(200, Event.error(dummyError)),
				next(300, Event.next(2)),
				next(400, Event.error(dummyError)),
				next(500, Event.next(3))
		]).asObservable()
	}

	override func tearDown() {
		super.tearDown()
		disposeBag = DisposeBag()
	}

	func test_elementsReturnsOnlyNextEvents() {
		let observer = testScheduler.createObserver(Int.self)

		eventObservable
				.elements()
				.subscribe(observer)
				.disposed(by: disposeBag)
		testScheduler.start()

		XCTAssertEqual(observer.events, [
				next(0, 0),
				next(100, 1),
				next(300, 2),
				next(500, 3)
		])
	}

	func test_errorsReturnsOnlyErrorEvents() {
		let observer = testScheduler.createObserver(Error.self)

		eventObservable
				.errors()
				.subscribe(observer)
				.disposed(by: disposeBag)
		testScheduler.start()

		XCTAssertEqual(observer.events.map { $0.time }, [200, 400])
		XCTAssertEqual(observer.events.map { $0.value.element! as NSError }, [dummyError, dummyError])
	}
}
