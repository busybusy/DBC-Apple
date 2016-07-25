//
//  DBC.swift
//
//  Created by Jim Boyd on 11/6/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//  Copyright (c) 2015-16 Busy, LLC. All rights reserved.
//
// Design by Contract Assertions
//
// The underlying theory of Design by Contract views software construction as
// based on contracts between clients (callers/consumers) and suppliers (routines),
// relying on mutual obligations and benefits made explicit by the assertions.
//
// DBC Assertions (require, check, ensure) play a central part in building reliable 
// object-oriented software. They serve to make explicit the assumptions on which 
// programmers rely when they write software elements that they believe are correct.
// Writing assertions amounts to spelling out the terms of the contract which governs 
// the relationship between a routine and its callers. The precondition binds the callers; 
// the postcondition binds the routine.
//
// Assertions are also an indispensable tool for the documentation of reusable
// software components: one cannot expect large-scale reuse without a precise
// documentation of what every component expects (precondition), what it guarantees
// in return (postcondition) and what general conditions it maintains (invariant).
//
// The following methods assist in "Design by contract".  Each will check the "condition"
// passed in.  If the condition fails, then each will display a message to the debugger 
// console and throw a swift assertion error, an attempt will also be made to break in the 
// debugger.
//
// Syntactically, these assertions are boolean expressions and although they perform
// identical tasks, each is semantically different.
//
// `require` is used to verify required preconditions as you enter a method.  If the
// contract specifies that certain conditions exist when entering a method, you should
// check these conditions with `require` before you start your method execution. Examples
// of its use includes checking that parameters passed in are within a required range or
// non-nil.
//
// `check` is used to check conditions within the body of a method.  If, in your method, you
// have a condition that must be true to safely execute the following code, you
// should `check` that condition. Examples of its use include checking that a pointer is
// non-nil after a function call that sets up the pointer, or that a value calculated
// within the body of the method is within a required range.
//
// `ensure` is used to ensure postconditions are true before you leave a method.  If the
// contract specifies that certain conditions exist before leaving a method, you should
// verify these conditions with `ensure` before you exit your method. Examples of its
// use include checking that values returned are within a required range or non-nil.
//
// For an explanation of the intensity parameters see DBCIntensityLevel.swift
//
// THE FINAL WORD.... one should not assume that everything is OK as you write code. Do
// not assume that an optional is non-nil before dereferencing and accessing
// the sub-data.  Do not assume that a value is not zero before dividing by it.  Do not
// assume that an index into an array is within bounds.  It should always be assumed that
// everything is screwed up.  Proper use of `require`, `check`, and `ensure` will help you
// be in control and assure yourself that conditions are safe without undue coding to
// test for these conditions.
//
// @see http://www.eiffel.com/developers/design_by_contract_in_detail.html
// @see http://youtu.be/v1phSCx_Vvg
// @see http://youtu.be/8XV0khSeKaw
// @see http://www.cs.unc.edu/~stotts/Eiffel/contract.html
// @see http://se.ethz.ch/~meyer/publications/computer/contract.pdf
// @see https://en.wikipedia.org/wiki/Design_by_contract
// @see http://research.microsoft.com/pubs/70290/tr-2006-54.pdf
// @see http://www.cs.usfca.edu/~parrt/course/601/lectures/programming.by.contract.html


import Foundation


// MARK: - Preconditions, introduced by the keyword require
/// Routine preconditions express the requirements that must be satisfied before a
/// routine is called by the client.

/// Check a necessary precondition for making forward progress.
///
/// Use this function to detect conditions that must prevent the
/// program from proceeding even in shipping code.
/// 
///
/// * In playgrounds and -Onone builds (the default for Xcode's Debug
///   configuration): if `condition` evaluates to false, stop program
///   execution in a debuggable state after printing `message`.
///
/// * In -O builds (the default for Xcode's Release configuration):
///   if `condition` evaluates to false, stop program execution.
///
/// * In -Ounchecked builds, `condition` is not evaluated, but the
///   optimizer may assume that it *would* evaluate to `true`. Failure
///   to satisfy that assumption in -Ounchecked builds is a serious
///   programming error.
///
/// - SeeAlso: precondition()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func require(@autoclosure condition:  () -> Bool, @autoclosure _ message: () -> String = "", intensity: Int = 0, file: StaticString = #file, line: UInt = #line) {
	if (intensity <= dbcIntensityLevel) {
		Assertions.precondition(condition(), "failed require : \(message())", file, line)
	}
	else {
		informIf(!condition(), "failed require(\(intensity)): \(message())", intensity: Int.min, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}
}

/// Indicate that a precondition was violated.
///
/// Use this function to stop the program when control flow can only
/// reach the call if your API was improperly used.
///
/// * In playgrounds and -Onone builds (the default for Xcode's Debug
///   configuration), stop program execution in a debuggable state
///   after printing `message`.
///
/// * In -O builds (the default for Xcode's Release configuration),
///   stop program execution.
///
/// * In -Ounchecked builds, the optimizer may assume that this
///   function will never be called. Failure to satisfy that assumption
///   is a serious programming error.
///
/// - SeeAlso: preconditionFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func requireFailure(@autoclosure message: () -> String, file: StaticString = #file, line: UInt = #line) {
	Assertions.preconditionFailure("failed require : \(message())", file, line)
}


// MARK: - Postconditions	, introduced by the keyword ensure
/// Postconditions express conditions that the routine (the supplier) 
/// guarantees on return, if the preconditions where satisfied on entry.

/// Check a promised postcondition before leaving a roiutine.
///.
/// Use this function to validate postconditions active during testing
/// but will not impact performance of shipping code.
///
/// - Note: Active during testing/debuging but will not impact performance of shipping code.
///
/// - SeeAlso: assert()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func ensure(@autoclosure condition: () -> Bool, @autoclosure _ message: () -> String = "", intensity: Int = 0, file: StaticString = #file, line: UInt = #line) {
#if DEBUG
	if (intensity <= dbcIntensityLevel) {
		Assertions.assert(condition(), "failed ensure : \(message())", file, line)
	}
	else {
		informIf(!condition(), "failed ensure(\(intensity)) : \(message())", intensity: Int.min, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}
#endif
}

/// Indicate that a postcondition was violated.
///
/// Use this function to stop the program, without impacting the
/// performance of shipping code, when control flow is not expected to
/// reach the call.
///
/// - Note: Active during testing/debuging but will not impact performance of shipping code.
///
/// - SeeAlso: assertFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func ensureFailure(@autoclosure message: () -> String, file: StaticString = #file, line: UInt = #line) {
#if DEBUG
	Assertions.assertionFailure("failed ensure : \(message())", file, line)
#endif
}

// MARK: - Runtime asssertions, introduced by the keyword check
/// Runtime checks express/assert the expected values of (computed) variables 
/// and their relationships within the routine.

/// Use this function for internal sanity checks that are active
/// during testing but will not impact performance of shipping code.
///
/// - Note: Active during testing/debuging but will not impact performance of shipping code.
///
/// - SeeAlso: assert()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func check(@autoclosure condition: () -> Bool, @autoclosure _ message: () -> String = "", intensity: Int = 0, file: StaticString = #file, line: UInt = #line) {
#if DEBUG
	if (intensity <= dbcIntensityLevel) {
		Assertions.assert(condition(), "failed check : \(message())", file, line)
	}
	else {
		informIf(!condition(), "failed check(\(intensity)) : \(message())", intensity: Int.min, debuggerBreak: dbcBreakOnAssertionsFailures, file: file, line: line)
	}
#endif
}

/// Indicate that an internal sanity check failed.
///
/// Use this function to stop the program, without impacting the
/// performance of shipping code, when control flow is not expected to
/// reach the call.
///
/// - Note: Active during testing/debuging but will not impact performance of shipping code.
///
/// - SeeAlso: assertFailure()
/// - SeeAlso: `DBCIntensityLevel.swift`
public func checkFailure(@autoclosure message: () -> String, file: StaticString = #file, line: UInt = #line) {
#if DEBUG
	Assertions.assertionFailure("failed check : \(message())", file, line)
#endif
}

/// Set to 'true' to break in the debugger when assertions fail yet are disabled due to intensity level.
///
/// DBC assertions that fail their condition but are silenced due to intensity level will still print the
/// failure to the debug console. When `dbcBreakOnAssertionsFailures` is `true` these conditions will also
/// break in the debugger.
///
/// Default is `false`
public var dbcBreakOnAssertionsFailures: Bool = false

// MARK: - Assertions class, custom assertions closures
/// Stores custom assertions closures, by default it points to Swift assertion functions, but test targets can override them.
/// - SeeAlso: XCTestCase+DBCAssertions.swift
public class Assertions {
	
	public static var assert              = swiftAssert
	public static var assertionFailure    = swiftAssertionFailure
	public static var precondition        = swiftPrecondition
	public static var preconditionFailure = swiftPreconditionFailure
	public static var fatalError          = swiftFatalError
	
	public static let swiftAssert              = { Swift.assert($0, $1, file: $2, line: $3) }
	public static let swiftAssertionFailure    = { Swift.assertionFailure($0, file: $1, line: $2) }
	public static let swiftPrecondition        = { Swift.precondition($0, $1, file: $2, line: $3) }
	public static let swiftPreconditionFailure = { Swift.preconditionFailure($0, file: $1, line: $2) }
	public static let swiftFatalError          = { Swift.fatalError($0, file: $1, line: $2) }
}
