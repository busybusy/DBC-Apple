//
//  DBCInform.h
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//


#ifndef __DBCAMIBEINGDEBUGGED__
#define __DBCAMIBEINGDEBUGGED__

/**
 DBCLog is a simple logging mechanism.  It is used by the various debugging/messaging facilities discussed.
 It is possible to use DBCLog directly. See also the INFORM facilities below for further functionality.
 In non-debug code, "DBCLog" results in a noop.
 */

#ifdef DEBUG
    #define DBCLog(...) NSLog(@"[%d] : %@",  __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
    #define DBCLog(...) ((void)0)
#endif



/**
 "INFORM" prints a message to the debugger console.
 "INFORM_IF" prints to the debugger console only if "condition" is true.
 
 The "INFORM" macros do not throw exceptions, and they are enabled
 only in debug code. In non-debug code, the "INFORM" macros
 result in a noop.
 
 The "intensity" argument is used in intense debugging situations.
 The "INFORM" will display its message if "intensity" is less than or
 equal to "gIntensityLevel".  If  "intensity" is greater than
 "gIntensityLevel" no message will be displayed.  The "INFORM" that has
 no "intensity" parameter will display its message without regard to
 the value of "gIntensityLevel".
 */

#ifdef DEBUG

#define INFORM_IF_INTENSE(intensity, condition, ...)    if ((DBC_DebugIntensityLevel() >= intensity) && (condition)) { DBCLog(__VA_ARGS__); }

#define INFORM_INTENSE(intensity, ...)                  INFORM_IF_INTENSE(intensity, true, __VA_ARGS__)

#define INFORM_IF(condition, ...)                       INFORM_IF_INTENSE(0, condition, __VA_ARGS__)

#define INFORM(...)                                     INFORM_IF_INTENSE(0, true, __VA_ARGS__)

#else
#define INFORM(...) ((void)0)
#define INFORM_INTENSE(...) ((void)0)
#define INFORM_IF(...) ((void)0)
#define INFORM_IF_INTENSE(...) ((void)0)
#endif


/**
 In debug code, "DEBUGGER_BREAK" forces a break in the debugger.
 In non-debug code, "DEBUGGER_BREAK" results in a noop.
 
 It is possible to use DEBUGGER_BREAK directly. It is preferred that BREAK and BREAK_IF be used as discussed below.
 */
#ifdef DEBUG
#if TARGET_CPU_ARM
#define DEBUGGER_BREAK() __asm__ __volatile__ ("mov r0, %0\nmov r1, %1\nmov r12, #37\nswi 128\n" : : "r" (getpid ()), "r" (signal) : "r12", "r0", "r1", "cc")
#elif TARGET_CPU_X86
#define DEBUGGER_BREAK() __asm__("int $3\n" : : )
#elif TARGET_CPU_X86_64
#define DEBUGGER_BREAK() __asm__("int $3\n" : : )
#elif TARGET_CPU_ARM64
#define DEBUGGER_BREAK() __asm__("svc 0")
#else
#warning "Not able to set a DebugBreak macro"
#define DEBUGGER_BREAK() 	((void)0)
#endif
#else
#define DEBUGGER_BREAK() 	((void)0)
#endif



/**
 @definedblock BREAK & BREAK_IF
 
 "BREAK" prints a message to the debugger console and breaks into the debugger.
 "BREAK_IF" prints and breaks only if "condition" is true.
 
 The "BREAK" macros do not throw exceptions, and they are enabled
 in both debug && messaging code. In non-debug || non-messaging code, the
 "BREAK" macros result in a noop.
 */

#if !TARGET_OS_WATCH && (defined(DEBUG) || defined(MESSAGING))

#define BREAK(...)                  do { DBCLog(__VA_ARGS__); DEBUGGER_BREAK(); } while(0)

#define BREAK_IF(condition, ...)    if ((condition)) { DBCLog(__VA_ARGS__); DEBUGGER_BREAK(); }

#else
#define BREAK(...) ((void)0)
#define BREAK_IF(...) ((void)0)
#endif



#endif
