//
//  NSDictionary+DictionaryValueValidation.m
//  AUTTheming
//
//  Created by Eric Horacek on 4/2/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

#import "NSDictionary+DictionaryValueValidation.h"
#import "AUTTheme.h"

@implementation NSDictionary (DictionaryValueValidation)

- (NSDictionary *)aut_dictionaryValueForKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    NSDictionary *value = self[key];
    // If there is no value for the specified key, is it not an error, just
    // return
    if (!value) {
        return nil;
    }
    // If the value for the specified key is a dictionary but is not a valid
    // type, return with error
    if (![value isKindOfClass:NSDictionary.class]) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The value for the key '%@' is not a dictionary",
                key];
            *error = [NSError
                errorWithDomain:AUTThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }
    return value;
}

@end
