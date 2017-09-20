//
//  Optional+Require.swift
//  Pods
//
//  Created by Jim Boyd on 5/11/17.
//	Based On:
//		https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift
//		https://github.com/JohnSundell/Require
//		https://www.reddit.com/r/swift/comments/6i9s16/reducing_boilerplate_of_critical_casts_while/
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
	func require(_ message: String? = nil, file: StaticString = #file, line: UInt = #line, method: StaticString = #function) -> Wrapped {
		var msg = "Required optional is nil."
		
		if let message = message, !message.isEmpty {
			msg = message
		}

		msg += " In \(method)."

		DBC.require(self != nil, msg, file: file, line: line)
		return self.unsafelyUnwrapped
	}
	
	/// Require this optional to contain a non-nil value that can be cast to type CastType
	///
	/// This method will either return the value that this optional contains, or trigger
	/// a `require` failure with an error message containing debug information.
	///
	/// - parameter message: Optionally pass a message that will get included in any error
	///                   message generated in case nil was found.
	///
	/// - SeeAlso: DBC.require()
	///
	/// - return: The value this optional contains cast to type CastType.
	func requireCast<CastType>(_ message: String? = nil, file: StaticString = #file, line: UInt = #line, method: StaticString = #function) -> CastType {
		guard let castValue = self.require(message, file:file, line:line, method:method) as? CastType else {
			var msg = ""
			
			if let message = message, !message.isEmpty {
				msg = message
			}
			else {
				msg = "Failed to cast value of type \(type(of: self)) to \(CastType.self)."
			}
			
			msg += " In \(method)."
			
			requireFailure(msg, file: file, line: line)
			return (self.unsafelyUnwrapped as! CastType)
		}
		
		return castValue
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
	func check(_ message: String? = nil, intensity: Int = 0, file: StaticString = #file, line: UInt = #line, method: StaticString = #function) -> Wrapped? {
		var msg = "Checked optional is nil."
		
		if let message = message, !message.isEmpty {
			msg = message
		}
		
		msg += " In \(method)"
		
		DBC.check(self != nil, msg, intensity:intensity, file: file, line: line)
		return self
	}
}
