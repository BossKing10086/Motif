//
//  MTFScreenBrightnessThemeApplier.m
//  Motif
//
//  Created by Eric Horacek on 4/4/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MTFScreenBrightnessThemeApplier.h"

@implementation MTFScreenBrightnessThemeApplier

#pragma mark - Lifecycle

static CGFloat const DefaultBrightnessThreshold = 0.5;

- (instancetype)initWithLightTheme:(MTFTheme *)lightTheme darkTheme:(MTFTheme *)darkTheme {
    return [self initWithScreen:UIScreen.mainScreen lightTheme:lightTheme darkTheme:darkTheme];
}

- (instancetype)initWithScreen:(UIScreen *)screen lightTheme:(MTFTheme *)lightTheme darkTheme:(MTFTheme *)darkTheme {
    NSParameterAssert(screen);
    NSParameterAssert(lightTheme);
    NSParameterAssert(darkTheme);
    
    MTFTheme *theme = [self
        themeForScreen:screen
        withBrightnessThreshold:DefaultBrightnessThreshold
        lightTheme:lightTheme
        darkTheme:darkTheme];
    
    self = [super initWithTheme:theme];

    _screen = screen;
    _lightTheme = lightTheme;
    _darkTheme = darkTheme;
    _brightnessThreshold = DefaultBrightnessThreshold;
    
    [NSNotificationCenter.defaultCenter
        addObserver:self
        selector:@selector(screenBrightnessDidChange:)
        name:UIScreenBrightnessDidChangeNotification
        object:_screen];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MTFDynamicThemeApplier

- (instancetype)initWithTheme:(MTFTheme *)theme {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (BOOL)setTheme:(MTFTheme *)theme error:(NSError **)error {
    NSParameterAssert(theme != nil);

    NSString *reason = [NSString stringWithFormat:
        @"The theme on a screen brightness theme applier may not be changed "\
            "manually."];

    @throw [NSException
        exceptionWithName:NSInternalInconsistencyException
        reason:reason
        userInfo:nil];
}

#pragma mark - MTFScreenBrightnessThemeApplier

- (MTFTheme *)themeForScreen:(UIScreen *)screen withBrightnessThreshold:(CGFloat)brightnessThreshold lightTheme:(MTFTheme *)lightTheme darkTheme:(MTFTheme *)darkTheme {
    NSParameterAssert(screen);
    NSParameterAssert(lightTheme);
    NSParameterAssert(darkTheme);
    
    return (screen.brightness > brightnessThreshold) ? lightTheme : darkTheme;
}

- (void)setBrightnessThreshold:(CGFloat)brightnessThreshold {
    _brightnessThreshold = brightnessThreshold;

    [self updateThemeIfNecessary];
}

- (void)updateThemeIfNecessary {
    MTFTheme *theme = [self
        themeForScreen:self.screen
        withBrightnessThreshold:self.brightnessThreshold
        lightTheme:self.lightTheme
        darkTheme:self.darkTheme];

    [super setTheme:theme error:NULL];
}

- (void)screenBrightnessDidChange:(NSNotification *)notification {
    [self updateThemeIfNecessary];
}

@end
