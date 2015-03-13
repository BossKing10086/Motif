//
//  ButtonsViewController.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import "ButtonsViewController.h"
#import "ButtonsView.h"
#import "ThemeSymbols.h"

@interface ButtonsViewController ()

@property (nonatomic) ButtonsView *view;

@end

@implementation ButtonsViewController

#pragma mark - UIViewController

@dynamic view;

- (void)loadView
{
    self.view = [ButtonsView new];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(toggleTheme)];
    self.navigationItem.title = @"Dynamic Theming";
    
    [self.themeApplier applyClassWithName:SpecThemeClassNames.Spec toObject:self.view];
}

#pragma mark - ButtonsViewController

- (instancetype)initWithThemeApplier:(AUTDynamicThemeApplier *)applier lightTheme:(AUTTheme *)lightTheme darkTheme:(AUTTheme *)darkTheme
{
    NSParameterAssert(applier);
    NSParameterAssert(lightTheme);
    NSParameterAssert(darkTheme);
    
    self = [super init];
    if (self) {
        _themeApplier = applier;
        _lightTheme = lightTheme;
        _darkTheme = darkTheme;
    }
    return self;
}

- (void)toggleTheme
{
    BOOL isCurrentlyDisplayingLightTheme = (self.themeApplier.theme == self.lightTheme);
    // Changing an AUTDynamicThemeApplier's theme property reapplies it to all previously applied themes
    self.themeApplier.theme = (isCurrentlyDisplayingLightTheme ? self.darkTheme : self.lightTheme);
}

@end
