/**
 @file          SUSimultorDictionary.m
 @package       simulator-udid
 @brief         Read all available Xcode simulators into a dictionary.

 @author        Edward Smith
 @date          September 23, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import "SUSimulatorDictionary.h"
#import "SUCommon.h"
#import "BNCLog.h"

NSDictionary*_Nullable SUSimulatorDictionaryWithError(NSError**error_) {
    NSError*error = nil;
    NSDictionary*result = nil;

    {
    BNCLogDebug(@"Getting simulators...");
    NSPipe*simListPipe = [[NSPipe alloc] init];
    NSTask*simListTask = [[NSTask alloc] init];
    // Run: xcrun simctl list -j devices
    simListTask.launchPath = @"/usr/bin/xcrun";
    simListTask.arguments = @[ @"simctl", @"list", @"-j", @"devices" ];
    simListTask.standardInput = [NSFileHandle fileHandleWithNullDevice];
    simListTask.standardOutput = simListPipe;
    [simListTask launch];
    NSMutableData*data = [NSMutableData data];
    do  {
        __auto_type chunk = [[simListPipe fileHandleForReading] readDataToEndOfFile];
        [data appendData:chunk];
    } while (simListTask.isRunning);
    error = SUErrorFromTaskTermination(simListTask);
    if (error) goto exit;

    result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) goto exit;
    }

exit:
    if (error_) *error_ = error;
    return result;
}
