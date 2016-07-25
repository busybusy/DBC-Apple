//
//  DBCAmIBeingDebugged.h
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//


#ifndef __DBCAMIBEINGDEBUGGED__
#define __DBCAMIBEINGDEBUGGED__

#ifdef __cplusplus
extern "C" {
#endif
	
#ifdef DEBUG
/// Returns true if the current process is being debugged (either
/// running under the debugger or has a debugger attached post facto).
bool DBC_AmIBeingDebbugged(void);
#endif
	
#ifdef __cplusplus
}
#endif

#endif
