//
//  AUTThemeConstant+Private.h
//  Pods
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeConstant.h"

@interface AUTThemeConstant ()

#pragma mark - Public

@property (nonatomic, copy) NSString *key;
@property (nonatomic) id rawValue;
@property (nonatomic) id mappedValue;

#pragma mark - Private

/**
 Cache to hold transformed values for the theme keyed by the transformer name.
 
 @see NSValueTransformer
 */
@property (nonatomic) NSCache *transformedValueCache;

@end
