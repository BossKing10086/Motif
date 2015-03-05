//
//  AUTThemeConstant.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/24/14.
//
//

#import "AUTThemeConstant.h"
#import "AUTThemeConstant+Private.h"

@implementation AUTThemeConstant

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToThemeConstant:object];
}

- (NSUInteger)hash
{
    return (self.key.hash ^ [self.rawValue hash] ^ [self.mappedValue hash]);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {%@: %@, %@: %@, %@: %@, %@: %@}",
        NSStringFromClass([self class]),
        NSStringFromSelector(@selector(key)), self.key,
        NSStringFromSelector(@selector(rawValue)), self.rawValue,
        NSStringFromSelector(@selector(mappedValue)), self.mappedValue,
        NSStringFromSelector(@selector(value)), self.value
    ];
}

#pragma mark - AUTThemeConstant

#pragma mark Public

@dynamic value;

- (id)value
{
    // If the mapped value is a reference to another constant, return that constant's value
    if ([self.mappedValue isKindOfClass:[AUTThemeConstant class]]) {
        AUTThemeConstant *mappedConstant = (AUTThemeConstant *)self.mappedValue;
        return mappedConstant.value;
    }
    // Otherwise, return either the mapped value or the raw value, in that order.
    return (self.mappedValue ?: self.rawValue);
}

#pragma mark Private

- (instancetype)initWithKey:(NSString *)key rawValue:(id)rawValue mappedValue:(id)mappedValue
{
    NSParameterAssert(key);
    NSParameterAssert(rawValue);
    self = [super init];
    if (self) {
        self.key = key;
        self.rawValue = rawValue;
        self.mappedValue = mappedValue;
    }
    return self;
}

#pragma mark Value Transformation

- (NSCache *)transformedValueCache
{
    if (!_transformedValueCache) {
        self.transformedValueCache = [NSCache new];
    }
    return _transformedValueCache;
}

- (id)transformedValueFromTransformerWithName:(NSString *)name
{
    id cachedValue = [self.transformedValueCache objectForKey:name];
    if (cachedValue) {
        return cachedValue;
    }
    
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:name];
    if (transformer) {
        id transformedValue = [transformer transformedValue:self.value];
        [self.transformedValueCache setObject:transformedValue forKey:name];
        return transformedValue;
    }
    
    return self.value;
}

#pragma mark Equality

- (BOOL)isEqualToThemeConstant:(AUTThemeConstant *)themeConstant
{
    if (!themeConstant) {
        return NO;
    }
    BOOL haveEqualKeys = (
        (!self.key && !themeConstant.key)
        || [self.key isEqualToString:themeConstant.key]
    );
    BOOL haveEqualRawValues = (
        (!self.rawValue && !themeConstant.rawValue)
        || [self.rawValue isEqual:themeConstant.rawValue]
    );
    BOOL haveEqualMappedValues = (
        (!self.mappedValue && !themeConstant.mappedValue)
        || [self.mappedValue isEqual:themeConstant.mappedValue]
    );
    return (
        haveEqualKeys
        && haveEqualRawValues
        && haveEqualMappedValues
    );
}

@end
