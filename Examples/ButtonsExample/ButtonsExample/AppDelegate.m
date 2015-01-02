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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSError *error;
    AUTTheme *theme = [AUTTheme themeFromURL:[[NSBundle mainBundle] URLForResource:@"Theme" withExtension:@"json"] error:&error];
    NSAssert(!error, @"Error when adding attributes to theme: %@", error);
    
    AUTThemeApplier *applier = [[AUTThemeApplier alloc] initWithTheme:theme];
    
    ButtonsViewController *viewController = [[ButtonsViewController alloc] initWithThemeApplier:applier];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
