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
import RxTest

private enum RepeatTestErrors : Error {
	case fatalError
}

class RetryWithBehaviorTests: XCTestCase {
	var sampleValues: TestableObservable<Int>!
    var sampleValuesImmediateError: TestableObservable<Int>!
    var sampleValuesNeverError: TestableObservable<Int>!
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
     
        sampleValuesImmediateError = scheduler.createColdObservable([
            error(230, RepeatTestErrors.fatalError),
            ])
        
        sampleValuesNeverError = scheduler.createColdObservable([
            next(210, 1),
            next(220, 2),
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
		
        let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
    func testImmediateRetryWithoutPredicate_ImmediateError() {
        let correctValues : [Recorded<Event<Int>>] = [
            error(690, RepeatTestErrors.fatalError)
        ]
        
        let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sampleValuesImmediateError.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler)
        }
        
        XCTAssertEqual(res.events, correctValues)
    }

    func testImmediateRetryWithoutPredicate_NoError() {
        let correctValues = [
            next(210, 1),
            next(220, 2),
            next(240, 3),
            next(250, 4),
            next(260, 5),
            next(270, 6),
            completed(300)
        ]
        
        let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sampleValuesNeverError.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler)
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
		
		// provide simple predicate that always return true
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler) { _ in
				true
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}

    func testImmediateRetryWithPredicate_Limited() {
        let correctValues = [
            next(210, 1),
            next(220, 2),
            next(440, 1),
            next(450, 2),
            error(460, RepeatTestErrors.fatalError)]
        
        // provide simple predicate that always return true
        var attempts = 0
        let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sampleValues.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler) { _ in
                attempts += 1
                return attempts == 1
            }
        }
        
        XCTAssertEqual(res.events, correctValues)
    }

	func testImmediateNotRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError)]
		
		// provide simple predicate that always return false (so, sequence will not repeated)
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.immediate(maxCount: 3), scheduler: self.scheduler) { _ in
				false
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
			next(680, 1),
			next(690, 2),
			error(700, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.delayed(maxCount: 3, time: 5.0), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}

	func testDelayedRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(445, 1),
			next(455, 2),
			next(680, 1),
			next(690, 2),
			error(700, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.delayed(maxCount: 3, time: 5.0), scheduler: self.scheduler) { _ in
				true
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testDelayedNotRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.delayed(maxCount: 3, time: 5.0), scheduler: self.scheduler) { _ in
				false
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testExponentialRetryWithoutPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(445, 1),
			next(455, 2),
			next(685, 1),
			next(695, 2),
			next(935, 1),
			next(945, 2),
			error(955, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.exponentialDelayed(maxCount: 4, initial: 5.0, multiplier: 1.0), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testExponentialRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(445, 1),
			next(455, 2),
			next(685, 1),
			next(695, 2),
			next(935, 1),
			next(945, 2),
			error(955, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.exponentialDelayed(maxCount: 4, initial: 5.0, multiplier: 1.0), scheduler: self.scheduler) { _ in
				true
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testExponentialNotRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError)]
		
		let res = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
			self.sampleValues.asObservable().retry(.exponentialDelayed(maxCount: 4, initial: 5.0, multiplier: 1.0), scheduler: self.scheduler) { _ in
				false
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testCustomTimerRetryWithoutPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(450, 1),
			next(460, 2),
			next(710, 1),
			next(720, 2),
			next(990, 1),
			next(1000, 2),
			next(1300, 1),
			next(1310, 2),
			error(1320, RepeatTestErrors.fatalError)]
		
		// custom delay calculator
		let customCalculator : (UInt) -> Double = { attempt in
			switch attempt {
			case 1: return 10.0
			case 2: return 30.0
			case 3: return 50.0
			default: return 80.0
			}
		}

		let res = scheduler.start(created: 0, subscribed: 0, disposed: 2000) {
			self.sampleValues.asObservable().retry(.customTimerDelayed(maxCount: 5, delayCalculator: customCalculator), scheduler: self.scheduler)
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testCustomTimerRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			next(450, 1),
			next(460, 2),
			next(710, 1),
			next(720, 2),
			next(990, 1),
			next(1000, 2),
			next(1300, 1),
			next(1310, 2),
			error(1320, RepeatTestErrors.fatalError)]
		
		// custom delay calculator
		let customCalculator: (UInt) -> Double = { attempt in
			switch attempt {
			case 1: return 10.0
			case 2: return 30.0
			case 3: return 50.0
			default: return 80.0
			}
		}

        let res = scheduler.start(created: 0, subscribed: 0, disposed: 2000) {
			self.sampleValues.asObservable().retry(.customTimerDelayed(maxCount: 5, delayCalculator: customCalculator), scheduler: self.scheduler) { _ in
				true
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
	
	func testCustomTimerNotRetryWithPredicate() {
		let correctValues = [
			next(210, 1),
			next(220, 2),
			error(230, RepeatTestErrors.fatalError)]
		
		// custom delay calculator
		let customCalculator: ((UInt) -> Double) = { attempt in
			switch attempt {
			case 1: return 10.0
			case 2: return 30.0
			case 3: return 50.0
			default: return 80.0
			}
		}

		let res = scheduler.start(created: 0, subscribed: 0, disposed: 2000) {
			self.sampleValues.asObservable().retry(.customTimerDelayed(maxCount: 5, delayCalculator: customCalculator), scheduler: self.scheduler) { _ in
				false
			}
		}
		
		XCTAssertEqual(res.events, correctValues)
	}
}
