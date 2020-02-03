/**
 @file          SUSimultorDictionary.h
 @package       simulator-udid
 @brief         Read all available Xcode simulators into a dictionary.

 @author        Edward Smith
 @date          September 23, 2019
 @copyright     -©- Copyright © 2019 Edward Smith. All rights reserved. -©-
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSDictionary*_Nullable SUSimulatorDictionaryWithError(NSError*_Nullable*error);

NS_ASSUME_NONNULL_END
