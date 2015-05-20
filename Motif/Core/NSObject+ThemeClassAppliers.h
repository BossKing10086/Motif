//
//  NSObject+ThemeAppliers.h
//  Motif
//
//  Created by Eric Horacek on 12/25/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFBackwardsCompatableNullability.h"

MTF_NS_ASSUME_NONNULL_BEGIN

@class MTFThemeClass;
@protocol MTFThemeClassApplicable;

/**
 A block that is invoked when a theme class is applied to an instance of the
 class that this applier is registered with.
 
 @param themeClass    The theme class that is being appled to the specified
                      object.
 @param objectToTheme The object that should have the specified class applied.
 */
typedef void (^MTFThemeClassApplierBlock)(MTFThemeClass *themeClass, id objectToTheme);

/**
 A block that is invoked to apply the property value to an instance of the class
 that this applier is registered with.
 
 @param propertyValue The property value that should be appled to the specified
                      object.
 @param objectToTheme The object that should have the specified property value
                      applied.
 */
typedef void (^MTFThemePropertyApplierBlock)(id propertyValue, id objectToTheme);

/**
 A block that is invoked to apply the property values to an instance of the
 class that this applier is registered with.
 
 @param valuesForProperties A dictionary of theme class properties keyed by
                            their names, with values of their theme property
                            values.
 @param objectToTheme       The object that should have the specified property
                            values applied.
 */
typedef void (^MTFThemePropertiesApplierBlock)(NSDictionary *valuesForProperties, id objectToTheme);

@interface NSObject (ThemeAppliers)

/**
 Registers a block that is invoked when a theme class is applied to an instance
 of the receiving classs.
 
 @param applierBlock The block that is invoked when the specified class is
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeClassApplierBlock:(MTFThemeClassApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply a property value to an instance of
 the receiving classs.
 
 @param property     The name of the theme class property that this applier
                     block is responsible for applying, e.g. "contentInsets".
 @param applierBlock The block that is invoked when the specified property is
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply a property value to an instance of
 the receiving classs.
 
 Before invoking the block, uses the specified value transformer to transform
 the property value.
 
 @param property        The name of the theme class property that this applier
                        block is responsible for applying, e.g. "contentInsets".
 @param transformerName The name of the value transformer used to transform
                        this value from the raw theme file to the value that is
                        a parameter to the applier block.
 @param applierBlock    The block that is invoked when the specified property is
                        applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property valueTransformerName:(NSString *)transformerName applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply a property value to an instance of
 the receiving classs.
 
 Before invoking the block, uses the specified class to ensure that the property
 value is a kind of the correct class.
 
 @param property     The name of the theme class property that this applier
                     block is responsible for applying, e.g. "contentInsets".
 @param valueClass   The class that the property value is required to be a kind
                     of.
 @param applierBlock The block that is invoked when the specified property is
                     applied to an instance of the receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property requiringValueOfClass:(Class)valueClass applierBlock:(MTFThemePropertyApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply the property values to an instance
 of the receiving classs.
 
 The block is only invoked when all of the specified properties are present.
 
 @param properties   The names of the theme class properties that this applier
                     block is responsible for applying.
 @param applierBlock The block that is invoked when the specified properties are
                     applied to an instance of the receiving class.

 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray *)properties applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

/**
 Registers a block that is invoked to apply the property values to an instance
 of the receiving classs.
 
 The block is only invoked when all of the specified properties are present.
 
 Before invoking the block, uses the specified value transformer to transform
 the property values, or uses the specified required class to ensure that the
 property values are a kind of the correct class.
 
 @param properties            The names of the theme class properties that this
                              applier block is responsible for applying.
 @param transformersOrClasses An array of value transformer names or required
                              classes in the same order as the property names.
 @param applierBlock          The block that is invoked when the specified
                              properties are applied to an instance of the 
                              receiving class.
 
 @return An opaque theme class applier. You may discard this reference.
 */
+ (id <MTFThemeClassApplicable>)mtf_registerThemeProperties:(NSArray *)properties valueTransformerNamesOrRequiredClasses:(NSArray *)transformersOrClasses applierBlock:(MTFThemePropertiesApplierBlock)applierBlock;

/**
 Registers a set of keywords that are each mapped to a specific value, such that
 when the specified propery is applied with one of the keywords as its value,
 its corresponding value is set for the specified keypath on the object that
 it was applied to.
 
 If the applied property value doesn't match the any of the keywords, an 
 exception is thrown.
 
 @param property        The name of the theme class property that this applier
                        is responsible for applying.
 @param keyPath         The keypath that the values in the valuesByKeyword
                        dictionary are set to.
 @param valuesByKeyword A dictionary that specifies a mapping from keywords in
                        theme class properties to values that are set for the
                        specified keypath.

 Examples
 
      // Applies a textAlignment theme property to UILabels
      [UILabel
          mtf_registerThemeProperty:@"textAlignment"
          forKeyPath:NSStringFromSelector(@selector(textAlignment))
          withValuesByKeyword:@{
              @"left": @(NSTextAlignmentLeft),
              @"center": @(NSTextAlignmentCenter),
              @"right": @(NSTextAlignmentRight),
              @"justified": @(NSTextAlignmentJustified),
              @"natural": @(NSTextAlignmentNatural)
          }];

 @return An opaque theme class applier. You may discard this reference.
 */
+ (id<MTFThemeClassApplicable>)mtf_registerThemeProperty:(NSString *)property forKeyPath:(NSString *)keyPath withValuesByKeyword:(NSDictionary *)valuesByKeyword;

/**
 Registers the specified theme class applier with the receiving class.
 
 @param applier The applier to register.
 */
+ (void)mtf_registerThemeClassApplier:(id <MTFThemeClassApplicable>)applier;

@end

MTF_NS_ASSUME_NONNULL_END
