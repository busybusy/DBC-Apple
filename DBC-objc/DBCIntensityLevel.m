//
//  DBCIntensityLevel.m
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//

#import "DBCIntensityLevel.h"

#ifdef DEBUG

#ifndef vIntenseDebugging
#define vIntenseDebugging 0
#endif

static NSInteger sIntensityLevel = vIntenseDebugging;
#undef vIntenseDebuggin

NSInteger DBC_DebugIntensityLevel()
{
	//	NSLog(@"sIntensityLevel = %ld : address = %lu  : size = %lu", (long)sIntensityLevel, (unsigned long)&sIntensityLevel, sizeof(sIntensityLevel));
	return sIntensityLevel;
}

void DBC_SetDebugIntensityLevel(NSInteger intensityLevel)
{
	sIntensityLevel = intensityLevel;
}

void DBC_performIfDBCIntensity(NSInteger intensity, void (^ _Nonnull block)())
{
	BOOL passesIntensity = (sIntensityLevel >= intensity);
	
	if (passesIntensity)
	{
		block();
	}
}

#endif
