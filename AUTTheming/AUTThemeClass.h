//
//  AUTThemeClass.h
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AUTTheme;

/**
 An AUTThemeClass represents a class from a JSON theme file.
 */
@interface AUTThemeClass : NSObject

/**
 The name of the theme class, as specified in the JSON theme file.
 */
@property (nonatomic, readonly) NSString *name;

/**
 The properties of the theme class as specified in the JSON theme file.
 
 This dictionary is keyed by property names with values of the properties values.
 */
@property (nonatomic, readonly) NSDictionary *properties;

@end
