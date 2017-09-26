//
//  RequiredOptionalTests.swift
//  DBC
//
//  Created by Jim Boyd on 5/11/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import DBC
import DBCTesting

class RequiredOptionalTests: XCTestCase {
	override func setUp() {
		super.setUp()
		dbcIntensityLevel = 0;
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testDBCAll() {
		let testStr: String? = "Test";
		_ = testStr.require()
		_ = testStr.check()
		
		let strings:[String]? = [testStr.require()]
		let nsstrings:[NSString] = strings.requireCast()
		print(nsstrings)
		
		// No good way to test this...
		// let nilStr: String? = nil;
		// expectCheck() { _ = nilStr.check() }

		// let ints:[Int]? = [13,11,12]
		// let intStrs:[String] = ints.requireCast()
		// print(intStrs)
	}
	
	func testDBCMessage() {
		
		let testStr: String? = "Test";
		_ = testStr.require("Test Message")
		_ = testStr.check("Test Message")
		
		// No good way to test this...
		// let nilStr: String? = nil;
		//expectRequire("Test Message") { _ = nilStr.require("Test Message") }
		//expectCheck("Test Message") { _ = nilStr.check("Test Message") }
	}
}
