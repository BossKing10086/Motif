//
//  NSURL+CLIHelpers.h
//  AUTThemingSymbolsGenerator
//
//  Created by Eric Horacek on 12/29/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CLIHelpers)

+ (NSURL *)aut_fileURLFromPathParameter:(NSString *)path;
+ (NSURL *)aut_directoryURLFromPathParameter:(NSString *)path;

@end
