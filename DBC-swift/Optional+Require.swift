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
	/// - return: The value this optional contains.
	func require(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Wrapped {
		var msg = message()
		
		if msg.isEmpty {
			msg = "Required optional is nil."
		}

		DBC.require(self != nil, msg, file: file, line: line)
		return self!
	}
}
