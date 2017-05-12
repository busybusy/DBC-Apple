//
//  Optional+Require.swift
//  Pods
//
//  Created by Jim Boyd on 5/11/17.
//	Based On:
//		https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift
//		https://github.com/JohnSundell/Require
//
//

import Foundation


public extension Optional {
	
	/// Require this optional to contain a non-nil value
	///
	/// This method will either return the value that this optional contains, or trigger
	/// a `require` failure with an error message containing debug information.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The value this optional contains.
	func require(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Wrapped {
		var msg = message()
		
		if msg.isEmpty {
			msg = "Required optional is nil."
		}

		DBC.require(self != nil, msg, file: file, line: line)
		return self!
	}
	
	/// Check this optional to contain a non-nil value
	///
	/// In debug builds it will trigger a `check` failure with an error message containing debug information.
	/// If the the check succeeds (or in non-debug builds) this method will always return `self` (nil or non-nil).
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.check()
	/// - SeeAlso: `DBCIntensityLevel.swift`
	///
	/// - return: The value this optional contains.
	func check(_ message: @autoclosure () -> String = "", intensity: Int = 0, file: StaticString = #file, line: UInt = #line) -> Wrapped? {
		var msg = message()
		
		if msg.isEmpty {
			msg = "Checked optional is nil."
		}
		
		DBC.check(self != nil, msg, intensity:intensity, file: file, line: line)
		return self
	}
}
