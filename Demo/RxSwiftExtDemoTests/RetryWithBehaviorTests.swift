//
//  RetryWithBehaviorTests.swift
//  RxSwiftExtDemo
//
//  Created by Anton Efimenko on 17.07.16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import XCTest
import RxSwift
import RxSwiftExt
import RxTests

enum RepeatTestErrors : ErrorType {
	case fatalError
}

class RetryWithBehaviorTests: XCTestCase {
	var sampleValues: TestableObservable<Int>!
	let scheduler = TestScheduler(initialClock: 0)
	
	override func setUp() {
		super.setUp()

		sampleValues = scheduler.createColdObservable([
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError),
			next(240, 3),
			next(250, 4),
			next(260, 5),
			next(270, 6),
			completed(300)
			])
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testImmediateRetryWithoutPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(440, 1),
			next(450, 2),
			next(670, 1),
			next(680, 2),
			error(690, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(0, subscribed: 0, disposed: 1000) { () -> Observable<Int> in
			return self.sampleValues.asObservable().retry(.Immediate(maxAttemptCount: 3), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	
	func testImmediateRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(440, 1),
			next(450, 2),
			next(670, 1),
			next(680, 2),
			error(690, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(0, subscribed: 0, disposed: 1000) { () -> Observable<Int> in
			return self.sampleValues.asObservable().retry(.Immediate(maxAttemptCount: 3), scheduler: self.scheduler) { error in
				return true
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testImmediateNotRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(0, subscribed: 0, disposed: 1000) { () -> Observable<Int> in
			return self.sampleValues.asObservable().retry(.Immediate(maxAttemptCount: 3), scheduler: self.scheduler) { error in
				return false
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testDelayedRetryWithoutPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(445, 1),
			next(455, 2),
			next(685, 1),
			next(695, 2),
			error(705, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(0, subscribed: 0, disposed: 1000) { () -> Observable<Int> in
			return self.sampleValues.asObservable().retry(.Delayed(maxAttemptCount: 3, time: 5.0), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}

}
