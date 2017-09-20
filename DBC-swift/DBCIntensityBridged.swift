//
//  DBCIntensityBridged.swift
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//

import Foundation

/// If using DBC in a project with both swift and objc-c source, and needing to set intensity levels in boh sources,
/// use `DBCBridge.intensityLevel` to set and keep in sync both the swift `dbcIntensityLevel` and obj-c
/// `DBC_DebugIntensityLevel` values.
///
/// - SeeAlso: `DBCIntensityLevel.swift`
/// - SeeAlso: `DBCIntensityLevel.h`
@objc public final class DBCBridge : NSObject {
	@objc static public var intensityLevel: Int = 0 {
		didSet {
			dbcIntensityLevel = intensityLevel
			#if DEBUG
			DBC_SetDebugIntensityLevel(intensityLevel);
			#endif
		}
	}
}
