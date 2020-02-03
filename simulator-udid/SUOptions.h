/**
 @file          SUOptions.h
 @package       simulator-udid
 @brief         Command line arguments.

 @author        Edward Smith
 @date          September 22, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUOptions : NSObject
@property (nonatomic, assign) BOOL showHelp;
@property (nonatomic, assign) NSInteger verbosity;
@property (nonatomic, assign) BOOL showVersion;
@property (nonatomic, assign) BOOL badOptionsError;
@property (nonatomic, assign) BOOL listSimulators;
@property (nonatomic, copy) NSString*_Nonnull simulatorName;
@property (nonatomic, copy) NSString*_Nonnull simulatorVersion;

+ (instancetype _Nonnull) optionsWithArgc:(int)argc argv:(char*const _Nullable[_Nullable])argv;
+ (NSString*) helpString;
@end

NS_ASSUME_NONNULL_END
