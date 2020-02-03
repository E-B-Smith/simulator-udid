/**
 @file          SUCommon.h
 @package       simulator-udid
 @brief         Common functions.

 @author        Edward Smith
 @date          September 23, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSError* NSErrorWithCodeFileLine(NSInteger code, NSString*filename, NSInteger linenumber);

#define NSErrorWithCode(code) \
    NSErrorWithCodeFileLine(code, @__FILE__, __LINE__)

FOUNDATION_EXPORT NSError*_Nullable SUWritef(NSFileHandle*file, NSString*format, ...) NS_FORMAT_FUNCTION(2,3);

FOUNDATION_EXPORT NSError*_Nullable SUErrorFromTaskTermination(NSTask*task);

NS_ASSUME_NONNULL_END
