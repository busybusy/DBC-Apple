//
//  DBCIntensityLevel.swift
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//

import Foundation

// MARK:- Intense assertions/messaging.

/// Introduces the concept of intense assertions/messaging. DBC assertion methods (and the included messaging methods)
/// allow for an intensity parameter who's default is zero. This allows you to enter intense assertions/messaging code
/// at some level greater then zero. You can leave the code in place without execution until that intensity level is
/// required. When it is desired to execute these intense assertions/messaging, set `dbcIntensityLevel` to the desired level,
/// all DBC assertion and message routines that are set at or below that level will then be activated. Resetting
/// `dbcIntensityLevel` back to zero (or to a lower level) will deactivate the assertions/messaging appropriately.
///
/// `dbcIntensityLevel` defaults to zero.
///
/// Setting `dbcIntensityLevel` to a value less then zero effectively disables assertions/messaging.
public var dbcIntensityLevel: Int = 0


/// Performs `block` closure if `intensity` is set at or below `dbcIntensityLevel`.
/// - Note: Active during testing/debuging but will not impact performance of shipping code.
/// - SeeAlso: dbcIntensityLevel
public func performIfDBCIntensity(_ intensity: Int, block: ()->Void)
{
#if DEBUG
	if (intensity <= dbcIntensityLevel) {
		block()
	}
#endif
}
