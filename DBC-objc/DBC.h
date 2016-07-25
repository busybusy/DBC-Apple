//
//	File:			SfDebug.h
//	Created:		June 3, 1999
//	Author:			Jim Boyd
//	Description:	Debug header file
//
//	Copyright CABOsoft, LLC 1999 - 2011, All Rights Reserved.
//
//	Design Reviewed:
//	Code Reviewed:
//

#ifndef __DBC__
#define __DBC__


// #define "DEBUG" to get DBC capabilities

/**
 DBCASSERT is a simple assertion mechanism.  If the condition fails, then a message will display a to the debugger
 console and an OBJ-C exception will be thrown. It is used by the DBC facilities discussed below.
 It is possible to use DBCASSERT directly. It is preferred that REQUIRE, CHECK and ENSURE be used as discussed below.

 TYPEDASSERT is a helper macros used in the facilities discussed below.
 It is possible to use the TYPEDASSERT macro directly but very inconvenient and not preferred.
*/

#ifdef DEBUG

#define TYPEDASSERT(type, intensity, condition, conditionStr, message, file, line)   \
	(((DBC_DebugIntensityLevel() >= intensity) && !__builtin_expect((BOOL)(condition), 0)) ? DBC_TYPEDASSERT_NO_RTN(type, conditionStr, message, @file, line) : (void)0)

//#define TYPEDASSERT(type, intensity, condition, conditionStr, message, file, line)   \
//		_TYPEDASSERT(type, intensity, (BOOL)(condition), conditionStr, message, @file, line)

	#define DBCASSERT(condition)          TYPEDASSERT(@"ASSERTION", 0, (condition), @#condition, @"", __FILE__, __LINE__)
    #define DBCASSERT_MSG(condition, ...)      TYPEDASSERT(@"ASSERTION", 0, (condition), @#condition, ([NSString stringWithFormat:__VA_ARGS__]), __FILE__, __LINE__)

#else
//    #define TYPEDASSERT(...) ((void)0)
    #define DBCASSERT(...) ((void)0)
    #define DBCASSERT_MSG(...) ((void)0)
#endif


/**
 @definedblock Design-By-Contract macros

 @abstract Used to validate Design-By-Contract conditions in the body of a method.

 @discussion
 Design by Contract Assertions

The underlying theory of Design by Contract views software construction as
 based on contracts between clients (callers/consumers) and suppliers (routines),
 relying on mutual obligations and benefits made explicit by the assertions.

 DBC Assertions (REQUIRE, CHECK, ENSURE) play a central part in building reliable
 object-oriented software. They serve to make explicit the assumptions on which
 programmers rely when they write software elements that they believe are correct.
 Writing assertions amounts to spelling out the terms of the contract which governs
 the relationship between a routine and its callers. The precondition binds the callers;
 the postcondition binds the routine.

 Assertions are also an indispensable tool for the documentation of reusable
 software components: one cannot expect large-scale reuse without a precise
 documentation of what every component expects (precondition), what it guarantees
 in return (postcondition) and what general conditions it maintains (invariant).

 In debug code, the following methods assist in "Design by contract".  Each will
 check the "condition" passed in.  If the condition fails, then each will display a
 message to the debugger console and throw a swift assertion error, an attempt will
 also be made to break in the debugger.

 Syntactically, these assertions are boolean expressions and although they perform
 identical tasks, each is semantically different.

 "REQUIRE" is used to verify required conditions as you enter a method.  If the
 contract specifies that certain conditions exist when entering a method, you should
 check these conditions with "REQUIRE" before you start your method execution. Examples
 of its use includes checking that parameters passed in are within a required range or
 non-nil.

 "CHECK" is used to check conditions in the body of a method.  If, in your method, you
 have a condition that must be true to safely execute the following code, you
 should "CHECK" that condition. Examples of its use include checking that a pointer is
 non-nil after a function call that sets up the pointer, or that a value calculated
 within the body of the method is within a required range.

 "ENSURE" is used to ensure return conditions before you leave a method.  If the
 contract specifies that certain conditions exist before leaving a method, you should
 verify these conditions with "ENSURE" before you exit your method. Examples of its
 use include checking that values returned are within a required range or non-nil.

 In non-debug code, these macros result in noops.

 THE FINAL WORD.... one should not assume that everything is OK as you write code. Do
 not assume that a pointer to a structure is non-nil before dereferencing and accessing
 the sub-data.  Do not assume that a value is not zero before dividing by it.  Do not
 assume that an index into an array is within bounds.  It should always be assumed that
 everything is screwed up.  Proper use of REQUIRE, CHECK, and ENSURE will help you
 be in control and assure yourself that conditions are safe without undue coding to
 test for these conditions.

 In all macros if gIntensityLevel > intensity and "condition" is true, throws an OBJ-C exception
 that indicates a failed DBC assertion and breaks in the debugger. Otherwise, does nothing.

 Note: in the macros without messages then the condition is printed in the debug output
 otherwise the message will be printed.

 @see http://www.eiffel.com/developers/design_by_contract_in_detail.html
 @see http://youtu.be/v1phSCx_Vvg
 @see http://youtu.be/8XV0khSeKaw
 @see http://www.cs.unc.edu/~stotts/Eiffel/contract.html
 @see http://se.ethz.ch/~meyer/publications/computer/contract.pdf
 @see https://en.wikipedia.org/wiki/Design_by_contract
 @see http://research.microsoft.com/pubs/70290/tr-2006-54.pdf
 @see https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Exceptions/Tasks/HandlingExceptions.html
 @see http://java.sun.com/docs/books/tutorial/essential/exceptions/index.html
 @see http://www.cs.usfca.edu/~parrt/course/601/lectures/programming.by.contract.html

 @throws NSException

 @define INTENSE_REQUIRE_MSG Require assertion that allows for setting a debug intensity level and a message.

 @define INTENSE_REQUIRE Require assertion that allows for setting a debug intensity level.

 @define REQUIRE_MSG Require assertion that allows for setting a debug message.

 @define REQUIRE Simple Require assertion

 @define INTENSE_CHECK_MSG Check assertion that allows for setting a debug intensity level and a message.

 @define INTENSE_CHECK Check assertion that allows for setting a debug intensity level.

 @define CHECK_MSG Check assertion that allows for setting a debug message.

 @define CHECK Simple Check assertion

 @define INTENSE_ENSURE_MSG Ensure assertion that allows for setting a debug intensity level and a message.

 @define INTENSE_ENSURE Ensure assertion that allows for setting a debug intensity level.

 @define ENSURE_MSG Ensure assertion that allows for setting a debug message.

 @define ENSURE Simple Ensure assertion

 @code
 int foo(int ** pointerList, int listIndex, int ptrIndex)
 {
 REQUIRE(pointerList != NULL);
 REQUIRE((listIndex >= 0) && (listIndex < someLimit));
 REQUIRE((ptrIndex >= 0) && (ptrIndex < someOtherLimit));

 int * ptr = pointerList[listIndex];
 CHECK(ptr != NULL);

 int returnValue = ptr[ptrIndex]
 ENSURE((returnValue >= valueMin) && (returnValue <= valueMax));

 return returnValue;
 }
 @endcode
 */

#ifdef DEBUG
	#define INTENSE_REQUIRE_MSG(intensity, condition, ...)	TYPEDASSERT(@"REQUIRE", (intensity), (condition), @#condition, ([NSString stringWithFormat:__VA_ARGS__]), __FILE__, __LINE__)

	#define INTENSE_REQUIRE(intensity, condition) INTENSE_REQUIRE_MSG(intensity, condition, @"")

	#define REQUIRE_MSG(condition, ...) INTENSE_REQUIRE_MSG(0, condition, __VA_ARGS__)

	#define REQUIRE(condition) INTENSE_REQUIRE_MSG(0, condition, @"")


	#define INTENSE_CHECK_MSG(intensity, condition, ...)	TYPEDASSERT(@"CHECK", (intensity), (condition), @#condition, ([NSString stringWithFormat:__VA_ARGS__]), __FILE__, __LINE__)

    #define INTENSE_CHECK(intensity, condition) INTENSE_CHECK_MSG(intensity, condition, @"")

    #define CHECK_MSG(condition, ...) INTENSE_CHECK_MSG(0, condition, __VA_ARGS__)

	#define CHECK(condition) INTENSE_CHECK_MSG(0, condition, @"")


    #define INTENSE_ENSURE_MSG(intensity, condition, ...)	TYPEDASSERT(@"ENSURE", (intensity), (condition), @#condition, ([NSString stringWithFormat:__VA_ARGS__]), __FILE__, __LINE__)

    #define INTENSE_ENSURE(intensity, condition) INTENSE_ENSURE_MSG(intensity, condition, @"")

    #define ENSURE_MSG(condition, ...) INTENSE_ENSURE_MSG(0, condition, __VA_ARGS__)

    #define ENSURE(condition) INTENSE_ENSURE_MSG(0, condition, @"")

#else	// non-debug

	#define INTENSE_REQUIRE_MSG(...) ((void)0)
	#define INTENSE_CHECK_MSG(...) ((void)0)
	#define INTENSE_ENSURE_MSG(...) ((void)0)

	#define INTENSE_REQUIRE(...) ((void)0)
	#define INTENSE_CHECK(...) ((void)0)
	#define INTENSE_ENSURE(...) ((void)0)

	#define REQUIRE_MSG(...)	 ((void)0)
	#define CHECK_MSG(...) ((void)0)
	#define ENSURE_MSG(...) ((void)0)
	#define ASSERT_MSG(...) ((void)0)

	#define REQUIRE(condition) ((void)0)
	#define CHECK(condition) ((void)0)
	#define ENSURE(condition) ((void)0)
	#define ASSERT(condition) ((void)0)

#endif

/**
 DBC_TYPEDASSERT and DBC_TYPEDASSERT_NO_RTN should be considered a private function, and are used as implementation details of the macros above.
*/

#ifdef __cplusplus
extern "C" {
#endif

#ifdef DEBUG
	#ifndef CLANG_NORETURN
	#if __has_feature(attribute_analyzer_noreturn)
		#define CLANG_NORETURN __attribute__((analyzer_noreturn))
	#else
		#define CLANG_NORETURN __attribute__((__noreturn__))
		#warning "analyzer_noreturn feature not avaliable for this version of clang compiler"
	#endif
	#endif

	void DBC_TYPEDASSERT_NO_RTN(NSString* __nonnull type, NSString* __nonnull  conditionStr, NSString* __nonnull message, NSString* __nonnull file, int line) CLANG_NORETURN;
#endif

#ifdef __cplusplus
}
#endif


#endif
