//
//  UINavigationBar+Theming.m
//  DynamicThemesExample
//
//  Created by Eric Horacek on 1/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import <AUTTheming/AUTTheming.h>
#import <AUTTheming/AUTValueTransformers.h>
#import "UINavigationBar+Theming.h"
#import "NavigationSymbols.h"
#import "UIColor+LightnessType.h"

@implementation UINavigationBar (Theming)

+ (void)load
{
    [self aut_registerThemeProperty:NavigationProperties.backgroundColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        navigationBar.barTintColor = color;
        navigationBar.translucent = NO;
        navigationBar.barStyle = ((color.lightnessType == LightnessTypeLight) ? UIBarStyleDefault : UIBarStyleBlack);
    }];
    
    [self aut_registerThemeProperty:NavigationProperties.tintColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        navigationBar.tintColor = color;
    }];
    
    [self aut_registerThemeProperties:@[
        NavigationProperties.fontName,
        NavigationProperties.fontSize
    ] valueTransformerNamesOrRequiredClasses:@[
        [NSString class],
        [NSNumber class]
    ] applierBlock:^(NSDictionary *valuesForProperties, UINavigationBar *navigationBar) {
        NSMutableDictionary *attributes = (navigationBar.titleTextAttributes ? [navigationBar.titleTextAttributes mutableCopy] : [NSMutableDictionary new]);
        NSString *name = valuesForProperties[NavigationProperties.fontName];
        CGFloat size = [valuesForProperties[NavigationProperties.fontSize] floatValue];
        UIFont *font = [UIFont fontWithName:name size:size];
        attributes[NSFontAttributeName] = font;
        navigationBar.titleTextAttributes = attributes;
    }];
    
    [self aut_registerThemeProperty:NavigationProperties.separatorColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        // Create an image of the specified color and set it as the shadow image
        CGRect shadowImageRect = (CGRect){CGPointZero, (CGSize){1.0, 0.5}};
        UIGraphicsBeginImageContextWithOptions(shadowImageRect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, shadowImageRect);
        UIImage *shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        // Allow image to be resized
        shadowImage = [shadowImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [navigationBar setShadowImage:shadowImage];
        // A 'backgroundImage' is required for the shadow image to work.
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }];
    
    [self aut_registerThemeProperty:NavigationProperties.textColor valueTransformerName:AUTColorFromStringTransformerName applierBlock:^(UIColor *color, UINavigationBar *navigationBar) {
        NSMutableDictionary *attributes = (navigationBar.titleTextAttributes ? [navigationBar.titleTextAttributes mutableCopy] : [NSMutableDictionary new]);
        attributes[NSForegroundColorAttributeName] = color;
        navigationBar.titleTextAttributes = attributes;
    }];
}

@end
