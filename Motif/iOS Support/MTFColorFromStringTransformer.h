//
//  MTFColorFromStringTransformer.h
//  Motif
//
//  Created by Eric Horacek on 12/23/14.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTFReverseTransformedValueClass.h"

MTF_NS_ASSUME_NONNULL_BEGIN

/**
 Transforms an NSString to a UIColor.
 
 See UIColor+HTMLColors.h for the accepted values.
 
 Does not allow reverse transformation.
 */
@interface MTFColorFromStringTransformer : NSValueTransformer <MTFReverseTransformedValueClass>

@end

/**
 The name of the value transformer responsible for transforming an NSString to
 a UIColor.
 */
extern NSString * const MTFColorFromStringTransformerName;

MTF_NS_ASSUME_NONNULL_END
