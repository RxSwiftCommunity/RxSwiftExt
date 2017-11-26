//
//  andTests.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 26/11/17
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

fileprivate enum AndTestsError: Error {
	case anyError
}

class andTests: XCTestCase {

	fileprivate func runAndObserve(_ sequence: Maybe<Bool>) -> TestableObserver<Bool> {
		let scheduler = TestScheduler(initialClock: 0)
		let observer = scheduler.createObserver(Bool.self)
		_ = sequence.asObservable().subscribe(observer)
		scheduler.start()
		return observer
	}

	func testSingle_oneTrueValue() {
		let source = Observable.just(true)
		let observer = runAndObserve(source.and())
		let correct = [
			next(0, true),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_oneFalseValue() {
		let source = Observable.just(false)
		let observer = runAndObserve(source.and())
		let correct = [
			next(0, false),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_emptySequence() {
		let source = Observable<Bool>.empty()
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_trueThenFalse() {
		let source = Observable.of(true, false)
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			next(0, false),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_falseThenTrue() {
		let source = Observable.of(false, true)
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			next(0, false),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_multipleTrue() {
		let source = Observable.of(true, true, true)
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			next(0, true),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_multipleTrueAndFalse() {
		let source = Observable.of(true, true, true, false, true, false, true)
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			next(0, false),
			completed(0)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_onlyError() {
		let source = Observable<Bool>.error(AndTestsError.anyError)
		let observer = runAndObserve(source.and())
		let correct: [Recorded<Event<Bool>>] = [
			error(0, AndTestsError.anyError)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_multipleValuesWithFalseThenError() {
		let scheduler = TestScheduler(initialClock: 0)
		let source = scheduler.createColdObservable([
			next(100, true),
			next(110, false),
			next(120, true),
			error(130, AndTestsError.anyError),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = source.and().asObservable().subscribe(observer)
		scheduler.start()

		let correct: [Recorded<Event<Bool>>] = [
			next(110, false),
			completed(110)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testSingle_multipleTrueValuesThenError() {
		let scheduler = TestScheduler(initialClock: 0)
		let source = scheduler.createColdObservable([
			next(100, true),
			next(110, true),
			next(120, true),
			error(130, AndTestsError.anyError),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = source.and().asObservable().subscribe(observer)
		scheduler.start()

		let correct: [Recorded<Event<Bool>>] = [
			error(130, AndTestsError.anyError)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testCollection_allTrue() {
		let scheduler = TestScheduler(initialClock: 0)
		let source1 = scheduler.createColdObservable([
			next(100, true),
			next(110, true),
			next(120, true),
			completed(130)
			])
		let source2 = scheduler.createColdObservable([
			next(50, true),
			next(107, true),
			completed(110)
			])
		let source3 = scheduler.createColdObservable([
			next(75, true),
			next(299, true),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = Observable
			.and([source1, source2, source3])
			.asObservable()
			.subscribe(observer)
		scheduler.start()

		let correct = [
			next(300, true),
			completed(300)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testCollection_trueAndEmpty() {
		let scheduler = TestScheduler(initialClock: 0)
		let source1 = scheduler.createColdObservable([
			next(100, true),
			next(120, true),
			completed(130)
			])
		let source2: TestableObservable<Bool> = scheduler.createColdObservable([
			completed(110)
			])
		let source3 = scheduler.createColdObservable([
			next(75, true),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = Observable
			.and([source1, source2, source3])
			.asObservable()
			.subscribe(observer)
		scheduler.start()

		let correct: [Recorded<Event<Bool>>] = [
			completed(300)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testCollection_someFalse() {
		let scheduler = TestScheduler(initialClock: 0)
		let source1 = scheduler.createColdObservable([
			next(100, true),
			next(110, false),
			next(120, true),
			completed(130)
			])
		let source2 = scheduler.createColdObservable([
			next(50, true),
			next(107, true),
			completed(110)
			])
		let source3 = scheduler.createColdObservable([
			next(75, true),
			next(299, true),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = Observable
			.and([source1, source2, source3])
			.asObservable()
			.subscribe(observer)
		scheduler.start()

		let correct = [
			next(110, false),
			completed(110)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testCollection_someFalseAndEmpty() {
		let scheduler = TestScheduler(initialClock: 0)
		let source1 = scheduler.createColdObservable([
			next(100, true),
			next(120, false),
			next(130, true),
			completed(200)
			])
		let source2: TestableObservable<Bool> = scheduler.createColdObservable([
			completed(110)
			])
		let source3 = scheduler.createColdObservable([
			next(75, true),
			next(299, true),
			completed(300)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = Observable
			.and([source1, source2, source3])
			.asObservable()
			.subscribe(observer)
		scheduler.start()

		let correct = [
			next(120, false),
			completed(120)
		]
		XCTAssertEqual(observer.events, correct)
	}

	func testCollection_falseAndEmptyAndError() {
		let scheduler = TestScheduler(initialClock: 0)
		let source1 = scheduler.createColdObservable([
			next(100, true),
			next(120, false),
			next(130, true),
			completed(200)
			])
		let source2: TestableObservable<Bool> = scheduler.createColdObservable([
			completed(110)
			])
		let source3 = scheduler.createColdObservable([
			next(75, true),
			error(100, AndTestsError.anyError)
			])

		let observer = scheduler.createObserver(Bool.self)
		_ = Observable
			.and([source1, source2, source3])
			.asObservable()
			.subscribe(observer)
		scheduler.start()

		let correct: [Recorded<Event<Bool>>] = [
			error(100, AndTestsError.anyError)
		]
		XCTAssertEqual(observer.events, correct)
	}
}
