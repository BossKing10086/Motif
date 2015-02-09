//
//  AppDelegate.m
//  ButtonsExample
//
//  Created by Eric Horacek on 12/27/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "AppDelegate.h"
#import "ButtonsViewController.h"
#import "ThemeSymbols.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSError *error;
    AUTTheme *theme = [AUTTheme themeFromThemeNamed:ThemeName error:&error];
    NSAssert(!error, @"Error when adding attributes to theme: %@", error);
    
    AUTThemeApplier *themeApplier = [[AUTThemeApplier alloc] initWithTheme:theme];
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithThemeApplier:themeApplier];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
