//
//  ButtonsViewController.h
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/1/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUTDynamicThemeApplier;
@class AUTTheme;

@interface ButtonsViewController : UIViewController

- (instancetype)initWithThemeApplier:(AUTDynamicThemeApplier *)themeApplier;

@property (nonatomic, readonly) AUTDynamicThemeApplier *themeApplier;

@end
