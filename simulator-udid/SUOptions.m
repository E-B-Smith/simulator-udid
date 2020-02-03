/**
 @file          SUOptions.m
 @package       simulator-udid
 @brief         Command line arguments.

 @author        Edward Smith
 @date          September 22, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import "SUOptions.h"
#import "BNCLog.h"
#include <getopt.h>

@implementation SUOptions

- (instancetype _Nonnull) init {
    self = [super init];
    if (!self) return self;
    self.simulatorName = @"";
    self.simulatorVersion = @"";
    return self;
}

+ (instancetype _Nonnull) optionsWithArgc:(int)argc argv:(char*const _Nullable[_Nullable])argv {
    __auto_type options = [[SUOptions alloc] init];

    static struct option long_options[] = {
        {"help",        no_argument,        NULL, 'h'},
        {"name",        required_argument,  NULL, 'n'},
        {"system",      required_argument,  NULL, 's'},
        {"device",      required_argument,  NULL, 'd'},
        {"list",        no_argument,        NULL, 'l'},
        {"verbose",     no_argument,        NULL, 'v'},
        {"version",     no_argument,        NULL, 'V'},
        {0, 0, 0, 0}
    };

    int c = 0;
    do {
        int option_index = 0;
        c = getopt_long(argc, argv, "hln:s:d:vV", long_options, &option_index);
        switch (c) {
        case -1:    break;
        case 'h':   options.showHelp = YES; break;
        case 'l':   options.listSimulators = YES; break;
        case 'n':   options.simulatorName = [self.class stringFromParameter]; break;
        case 's':   options.simulatorVersion = [self.class stringFromParameter]; break;
        case 'd': {
            NSString*name,*version;
            NSString*device = [self.class stringFromParameter];
            if ([self parseDevice:device name:&name version:&version]) {
                options.simulatorName = name;
                options.simulatorVersion = version;
            } else {
                options.badOptionsError = YES;
                BNCLogError(@"Bad device parameter format.");
            }
            break;
        }
        case 'v':   options.verbosity++; break;
        case 'V':   options.showVersion = YES; break;
        default:    options.badOptionsError = YES; break;
        }
    } while (c != -1 && !options.badOptionsError);

    return options;
}

+ (NSString*) stringFromParameter {
    return [NSString stringWithCString:optarg encoding:NSUTF8StringEncoding];
}

+ (BOOL) parseDevice:(NSString*)device name:(NSString**)name_ version:(NSString**)version_ {
    NSString*name;
    NSString*version;

    {
    NSScanner*scanner = [NSScanner scannerWithString:device];
    if (![scanner scanString:@"name" intoString:NULL]) goto exit;
    if (![scanner scanString:@"=" intoString:NULL]) goto exit;
    [scanner scanUpToString:@"," intoString:&name];
    if (![scanner scanString:@"," intoString:NULL]) goto exit;
    if (![scanner scanString:@"OS" intoString:NULL]) goto exit;
    if (![scanner scanString:@"=" intoString:NULL]) goto exit;
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&version];
    }

exit:
    if (name_) *name_ = name;
    if (version_) *version_ = version;
    return (name.length !=  0 && version.length != 0);
}

+ (NSString*) helpString {
    return
@"usage: simulator-udid [-hvV] [ -l ] | [ -n <simulator-name> -s <simulator-system> ] | -d <simulator-device> ]\n"
"\n"
"    -h --help      Show help.\n"
"    -n --name      The simultor name, like 'iPhone 6s'.\n"
"    -l --list      List the simulators and exit.\n"
"    -s --system    The simulator system, like '12.2'.\n"
"    -d --device    The simulator device, like 'name=iPhone 6s,OS=12.2'\n"
"    -v --verbose   Verbose.\n"
"    -V --version   Show version.\n"
"\n"
"Returns a simulator udid given a name and system version.\n";
}

@end
