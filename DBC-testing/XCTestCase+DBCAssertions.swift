//
//  XCTestCase+DBCAssertions.swift
//  Assertions
//
//  Created by Mohamed Afifi on 12/20/15.
//  Copyright © 2015 mohamede1945. All rights reserved.
//

/// ### IMPORTANT HOW TO USE ###
/// 1. Drop `ProgrammerAssertions.swift` to the target of your app or framework under test. Just besides your source code.
/// 2. Drop `XCTestCase+ProgrammerAssertions.swift` to your test target. Just besides your test cases.
/// 3. Use `assert`, `assertionFailure`, `precondition`, `preconditionFailure` and `fatalError` normally as you always do.
/// 4. Unit test them with the new methods `expectAssert`, `expectAssertionFailure`, `expectPrecondition`, `expectPreconditionFailure` and `expectFatalError`.
///
/// This file is the unit test assertions.
/// For a complete project example see <https://github.com/mohamede1945/AssertionsTestingExample>

import Foundation
import XCTest
import class DBC.Assertions

private let noReturnFailureWaitTime = 0.1

private protocol DBCTestType {
	func expect(xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: () -> Void)
}

public extension XCTestCase {
	/**
	Expects an `require` to be called with a false condition.
	If `require` not called or the require's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `require`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectRequire(expectedMessage: String? = nil, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
			DBCType.require.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
		}
	
	/**
	Expects an `requireFailure` to be called.
	If `requireFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `requireFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectRequireFailure(expectedMessage: String, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
		DBCFailureType.requireFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `check` to be called with a false condition.
	If `check` not called or the check's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `check`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectCheck(expectedMessage: String? = nil, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
		DBCType.check.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `checkFailure` to be called.
	If `checkFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `checkFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectCheckFailure(expectedMessage: String, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
		DBCFailureType.checkFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `ensure` to be called with a false condition.
	If `ensure` not called or the ensure's condition is true, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `ensure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectEnsure(expectedMessage: String? = nil, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
		DBCType.ensure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
	
	/**
	Expects an `ensureFailure` to be called.
	If `ensureFailure` not called, the test case will fail.
	
	- parameter expectedMessage: The expected message to be asserted to the one passed to the `ensureFailure`. If nil, then ignored.
	- parameter file:            The file name that called the method.
	- parameter line:            The line number that called the method.
	- parameter testCase:        The test case to be executed that expected to fire the assertion method.
	*/
	public func expectEnsureFailure(expectedMessage: String, file: StaticString = #file, line: UInt = #line, testCase: () -> Void) {
		DBCFailureType.ensureFailure.expect(self, expectedMessage: expectedMessage, file: file, line: line, testCase: testCase)
	}
}

extension  DBCTestType {
	private func resetAssertionWrapper() {
		Assertions.precondition = Assertions.swiftPrecondition
		Assertions.preconditionFailure = Assertions.swiftPreconditionFailure
		Assertions.assert = Assertions.swiftAssert
		Assertions.assertionFailure = Assertions.swiftAssertionFailure
	}
}

private enum DBCType : String, DBCTestType{
	case require
	case check
	case ensure
	
	func expect(xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: () -> Void) {
		var dbcMessage = self.dbcMessage()
		
		if let expectedMessage = expectedMessage where !expectedMessage.isEmpty {
			dbcMessage += expectedMessage
		}
		
		assertionReturnFunction(xcTest, file: file, line: line, stubFunction: {
			(caller) -> () in
			self.updateAssertionWrapper(caller)
			
		}, expectedMessage: dbcMessage, testCase: testCase) {
			() -> () in
			self.resetAssertionWrapper()
		}
	}
	
	func dbcMessage() -> String {
		switch self {
		case require:
			return "failed require : "
		case check:
			return "failed check : "
		case ensure:
			return "failed ensure : "
		}
	}
	
	func updateAssertionWrapper(caller: (Bool, String) -> Void) {
		switch self {
		case require:
			Assertions.precondition = { condition, message, _, _ in
				caller(condition, message)
			}
		case check:
			Assertions.assert = { condition, message, _, _ in
				caller(condition, message)
			}
		case ensure:
			Assertions.assert = { condition, message, _, _ in
				caller(condition, message)
			}
		}
	}
	
	func assertionReturnFunction(xcTest: XCTestCase, file: StaticString, line: UInt, stubFunction: (caller: (Bool, String) -> Void) -> Void,
		expectedMessage: String? = nil, testCase: () -> Void, cleanUp: () -> ()) {
		
		let expectation = xcTest.expectationWithDescription(self.rawValue + "-Expectation")
		var assertion: (condition: Bool, message: String)? = nil
		
		stubFunction { (condition, message) -> Void in
			assertion = (condition, message)
			expectation.fulfill()
		}
		
		// perform on the same thread since it will return
		testCase()
		
		xcTest.waitForExpectationsWithTimeout(noReturnFailureWaitTime) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertion = assertion else {
				XCTFail(self.rawValue + " is expected to be called.", file: file, line: line)
				return
			}
			
			XCTAssertFalse(assertion.condition, self.rawValue + " condition expected to be false", file: file, line: line)
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertion.message, expectedMessage, self.rawValue + " called with incorrect message.", file: file, line: line)
			}
		}
	}
}

private enum DBCFailureType : String, DBCTestType {
	case requireFailure
	case checkFailure
	case ensureFailure
	
	func expect(xcTest: XCTestCase, expectedMessage: String?, file: StaticString, line: UInt, testCase: () -> Void) {
		var dbcMessage = self.dbcMessage()
		
		if let expectedMessage = expectedMessage where !expectedMessage.isEmpty {
			dbcMessage += expectedMessage
		}
		
		assertionReturnFunction(xcTest, file: file, line: line, stubFunction: {
			(caller) -> () in
			self.updateAssertionFailureWrapper(caller)
			
		}, expectedMessage: dbcMessage, testCase: testCase) {
			() -> () in
			self.resetAssertionWrapper()
		}
	}
	
	func dbcMessage() -> String {
		switch self {
		case requireFailure:
			return "failed require : "
		case checkFailure:
			return "failed check : "
		case ensureFailure:
			return "failed ensure : "
		}
	}
	
	func updateAssertionFailureWrapper(caller: (String) -> Void) {
		switch self {
		case requireFailure:
			Assertions.preconditionFailure = { message, _, _ in
				caller(message)
			}
		case checkFailure:
			Assertions.assertionFailure = { message, _, _ in
				caller(message)
			}
		case ensureFailure:
			Assertions.assertionFailure = { message, _, _ in
				caller(message)
			}
		}
	}

	func assertionReturnFunction(xcTest: XCTestCase, file: StaticString, line: UInt, stubFunction: (caller: (String) -> Void) -> Void,
	                             expectedMessage: String? = nil, testCase: () -> Void, cleanUp: () -> ()) {
		let expectation = xcTest.expectationWithDescription(self.rawValue + "-Expectation")
		var assertionMessage: String? = nil
		
		stubFunction { (message) -> Void in
			assertionMessage = message
			expectation.fulfill()
		}
		
		// act, perform on separate thead because a call to function runs forever
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), testCase)
		
		xcTest.waitForExpectationsWithTimeout(noReturnFailureWaitTime) { _ in
			
			defer {
				// clean up
				cleanUp()
			}
			
			guard let assertionMessage = assertionMessage else {
				XCTFail(self.rawValue + " is expected to be called.", file: file, line: line)
				return
			}
			
			if let expectedMessage = expectedMessage {
				// assert only if not nil
				XCTAssertEqual(assertionMessage, expectedMessage, self.rawValue + " called with incorrect message.", file: file, line: line)
			}
		}
	}
}

