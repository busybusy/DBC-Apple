//
//	File:			SfDebug.cpp
//	Created:		June 3, 1999
//	Author:			Jim Boyd
//	Description:	Debug support
//
//	Copyright CABOsoft, LLC 1999 - 2011, All Rights Reserved.
//
#include "DBC.h"
#import "DBCAmIBeingDebugged.h"
#import "DBCIntensityLevel.h"

#ifdef DEBUG
void DBC_TYPEDASSERT_NO_RTN(NSString* type, NSString* conditionStr, NSString* message, NSString* file, int line)
{
	NSString* messageStr = @"Ouch";
	
	// conditionStr should always have content
	assert(conditionStr.length > 0);
	
	if (message.length > 0)
	{
		messageStr = [NSString stringWithFormat:@"FAILED %@: (%@) : %@ : at %@(%d)", type, conditionStr, message, file, line];
	}
	else
	{
		messageStr = [NSString stringWithFormat:@"FAILED %@: (%@) : at %@(%d)", type, conditionStr, file, line];
	}

//	DBCLogError(@"%@", messageStr);
//	DEBUGGER_BREAK();
	
	[NSException raise:type format:@"%@", messageStr];
}

#endif
