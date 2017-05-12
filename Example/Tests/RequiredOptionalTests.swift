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
		
		// No good way to test this...
		// let nilStr: String? = nil;
		// expectRequire() { _ = nilStr.require() }
	}
	
	func testDBCMessage() {
		
		let testStr: String? = "Test";
		_ = testStr.require("Test Message")
		
		// No good way to test this...
		// let nilStr: String? = nil;
		//expectRequire("Test Message") { _ = nilStr.require("Test Message") }
	}
}
