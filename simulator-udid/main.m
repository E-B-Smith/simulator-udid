/**
 @file          main.m
 @package       simulator-udid
 @brief         Command line utility that returns a simulator udid given a device name and version.

 @author        Edward Smith
 @date          September 22, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import <Foundation/Foundation.h>
#import <sysexits.h>
#import "SUOptions.h"
#import "SUCommon.h"
#import "SUSimulatorDictionary.h"
#import "BNCLog.h"

@interface SUDevice : NSObject
@property NSString*name;
@property NSString*version;
@property NSString*udid;
@end

@implementation SUDevice
@end

#pragma mark -

static BNCLogLevel global_logLevel = BNCLogLevelWarning;

void LogOutputFunction(
        NSDate*_Nonnull timestamp,
        BNCLogLevel level,
        NSString *_Nullable message
    ) {
    if (level < global_logLevel || !message) return;
    NSRange range = [message rangeOfString:@") "];
    if (range.location != NSNotFound) {
        message = [message substringFromIndex:range.location+2];
    }
    NSData *data = [message dataUsingEncoding:NSNEXTSTEPStringEncoding];
    if (!data) return;
    int descriptor = (level == BNCLogLevelLog) ? STDOUT_FILENO : STDERR_FILENO;
    write(descriptor, data.bytes, data.length);
    write(descriptor, "\n   ", sizeof('\n'));
}

int main(int argc, char*const argv[]) {
    int returnCode = EXIT_FAILURE;
    @autoreleasepool {
        BNCLogSetOutputFunction(LogOutputFunction);
        BNCLogSetDisplayLevel(BNCLogLevelWarning);

        __auto_type options = [SUOptions optionsWithArgc:argc argv:argv];
        if (options.badOptionsError) {
            returnCode = EX_USAGE;
            goto exit;
        }
        if (options.showHelp) {
            NSData *data = [[SUOptions helpString] dataUsingEncoding:NSUTF8StringEncoding];
            write(STDOUT_FILENO, data.bytes, data.length);
            returnCode = EXIT_SUCCESS;
            goto exit;
        }
        if (options.showVersion) {
            __auto_type version = [NSString stringWithFormat:@"%@(%@)\n",
                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
            ];
            NSData *data = [version dataUsingEncoding:NSUTF8StringEncoding];
            write(STDOUT_FILENO, data.bytes, data.length);
            returnCode = EXIT_SUCCESS;
            goto exit;
        }
        global_logLevel =
            MIN(MAX(BNCLogLevelWarning - options.verbosity, BNCLogLevelAll), BNCLogLevelNone);
        BNCLogSetDisplayLevel(global_logLevel);

        NSError*error = nil;
        NSFileHandle*stdError = [NSFileHandle fileHandleWithStandardError];
        __auto_type dictionary = SUSimulatorDictionaryWithError(&error);
        if (error) {
            SUWritef(stdError, @"%@", error);
            returnCode = EXIT_FAILURE;
            goto exit;
        }

        NSFileHandle*stdOut = [NSFileHandle fileHandleWithStandardOutput];
        if (options.listSimulators) {
            NSMutableArray*deviceList = [NSMutableArray array];
            NSDictionary*runtimes = dictionary[@"devices"];
            for (NSString*runtimeName in runtimes.keyEnumerator) {
                NSArray*devices = runtimes[runtimeName];
                NSInteger idx = @"com.apple.CoreSimulator.SimRuntime.".length;
                NSString*runtime = [runtimeName substringFromIndex:MIN(runtimeName.length, idx)];
                __auto_type range = [runtime rangeOfString:@"-"];
                runtime = [runtime stringByReplacingCharactersInRange:range withString:@" "];
                runtime = [runtime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                for (NSDictionary*device in devices) {
                    SUDevice*d = [SUDevice new];
                    d.name = device[@"name"];
                    d.udid = device[@"udid"];
                    d.version = runtime;
                    [deviceList addObject:d];
                }
            }
            [deviceList sortUsingComparator:
            ^ NSComparisonResult(SUDevice*_Nonnull obj1, SUDevice*_Nonnull obj2) {
                __auto_type result = [obj1.name compare:obj2.name];
                if (result == NSOrderedSame) {
                    result = [obj1.version compare:obj2.version];
                }
                return result;
            }];
            for (SUDevice*device in deviceList) {
                SUWritef(stdOut, @"%@ %@ %@", device.name, device.version, device.udid);
            }
            returnCode = EXIT_SUCCESS;
            goto exit;
        }

        NSString*version = [options.simulatorVersion stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        version = [NSString stringWithFormat:@"com.apple.CoreSimulator.SimRuntime.iOS-%@", version];
        NSArray*deviceArray = dictionary[@"devices"][version];
        for (NSDictionary*simulator in deviceArray) {
            NSString*name = simulator[@"name"];
            if ([name isKindOfClass:NSString.class] && [name isEqualToString:options.simulatorName])
                SUWritef(stdOut, @"%@", simulator[@"udid"]);
        }

    returnCode = EXIT_SUCCESS;
    }
exit:
    return returnCode;
}
