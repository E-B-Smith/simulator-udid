/**
 @file          SUCommon.m
 @package       simulator-udid
 @brief         Common functions.

 @author        Edward Smith
 @date          September 23, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import "SUCommon.h"

NSError* NSErrorWithCodeFileLine(NSInteger code, NSString*filename, NSInteger linenumber) {
    filename = [filename lastPathComponent];
    return [NSError errorWithDomain:NSCocoaErrorDomain code:code userInfo:@{
        @"Filename": (filename) ? filename : @"None",
        @"Linenumber": @(linenumber)
    }];
}

NSError*_Nullable SUWritef(NSFileHandle*file, NSString*format, ...) {
    va_list args;
    va_start(args, format);
    NSMutableString* message = [[NSMutableString alloc] initWithFormat:format arguments:args];
    [message appendString:@"\n"];
    va_end(args);
    @try {
        [file writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    } @catch (NSException *exception) {
        return NSErrorWithCode(NSFileWriteUnknownError);
    }
    return nil;
}

NSError*_Nullable SUErrorFromTaskTermination(NSTask*task) {
    if (task.terminationStatus != 0) {
        return [NSError errorWithDomain:NSPOSIXErrorDomain code:task.terminationStatus userInfo:nil];
    }
    if (task.terminationReason != NSTaskTerminationReasonExit) {
        return [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:nil];
    }
    return nil;
}
