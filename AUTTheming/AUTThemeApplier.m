//
//  AUTThemeApplier.m
//  Pods
//
//  Created by Eric Horacek on 12/26/14.
//
//

#import <objc/runtime.h>
#import "AUTThemeApplier.h"
#import "AUTThemeConstant.h"
#import "AUTThemeClass+Private.h"

@interface AUTThemeClassApplier ()

@property (nonatomic, copy) AUTThemeClassApplierBlock applier;

@end

@implementation AUTThemeClassApplier

#pragma mark - AUTThemeClassApplier

- (instancetype)initWithClassApplier:(AUTThemeClassApplierBlock)applier
{
    NSParameterAssert(applier);
    self = [super init];
    if (self) {
        self.applier = applier;
    }
    return self;
}

#pragma mark - AUTThemeClassApplier <AUTThemeApplier>

@dynamic properties;

- (NSArray *)properties
{
    return @[];
}

- (void)applyClass:(AUTThemeClass *)class fromTheme:(AUTTheme *)theme toObject:(id)object;
{
    NSParameterAssert(object);
    
    self.applier(object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    return YES;
}

@end

@interface AUTThemePropertyApplier ()

@property (nonatomic, copy) NSString *property;
@property (nonatomic, copy) NSString *valueTransformerName;
@property (nonatomic) Class requiredClass;
@property (nonatomic, copy) AUTThemePropertyApplierBlock applier;

@end

@implementation AUTThemePropertyApplier

#pragma mark - AUTThemePropertyApplier

- (instancetype)initWithProperty:(NSString *)property applier:(AUTThemePropertyApplierBlock)applier valueTransformerName:(NSString *)name requiredClass:(Class)class
{
    NSParameterAssert(property);
    NSParameterAssert(applier);
    self = [super init];
    if (self) {
        self.property = property;
        self.applier = applier;
        self.valueTransformerName = name;
        self.requiredClass = class;
    }
    return self;
}

+ (id)valueFromConstant:(AUTThemeConstant *)constant forProperty:(NSString *)property onObject:(id)object withRequiredClass:(Class)requiredClass valueTransformerName:(NSString *)valueTransformerName
{
    NSAssert(constant, @"Constant must not be nil");
    id value = constant.mappedValue;
    
    // Enforce required class if necessary
    if (requiredClass) {
        BOOL isValueOfRequiredClass = [value isKindOfClass:requiredClass];
        if (!isValueOfRequiredClass) {
            NSString *applierClassName = NSStringFromClass([object class]);
            NSString *requiredClassName = NSStringFromClass(requiredClass);
            NSString *valueClassName = NSStringFromClass([value class]);
            NSAssert(isValueOfRequiredClass, @"The theme applier on '%@' requires that the value for property '%@' is of class '%@'. It is instead an instace of '%@'", applierClassName, requiredClassName, property, valueClassName);
        }
    }
    
    // Transform value if necessary
    if (valueTransformerName) {
        NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:valueTransformerName];
        NSAssert(valueTransformer, @"There is no value transfomer registered for the name '%@'. Before applying a theme, you must first register a value transformer instance using `+[NSValueTransformer setValueTransformer:forName:]` for the specified name.", valueTransformerName);
        id transformedValue = [constant transformedValueFromTransformerWithName:valueTransformerName];
        value = transformedValue;
    }
    
    return value;
}

#pragma mark - AUTThemePropertyApplier <AUTThemeApplier>

@dynamic properties;

- (NSArray *)properties
{
    return @[self.property];
}

- (void)applyClass:(AUTThemeClass *)class fromTheme:(AUTTheme *)theme toObject:(id)object;
{
    NSParameterAssert(class);
    NSParameterAssert(theme);
    NSParameterAssert(object);
    
    AUTThemeConstant *constant = class.resolvedPropertiesConstants[self.property];
    
    id value = [[self class] valueFromConstant:constant forProperty:self.property onObject:object withRequiredClass:self.requiredClass valueTransformerName:self.valueTransformerName];
    
    self.applier(value, object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    return [class.properties.allKeys containsObject:self.property];
}

@end

@interface AUTThemePropertiesApplier ()

@property (nonatomic, copy) AUTThemePropertiesApplierBlock applier;
@property (nonatomic) NSArray *properties;
@property (nonatomic) NSArray *valueTransformersOrRequiredClasses;

@end

@implementation AUTThemePropertiesApplier

#pragma mark - AUTThemePropertiesApplier

- (instancetype)initWithProperties:(NSArray *)properties valueTransformersOrRequiredClasses:(NSArray *)valueTransformersOrRequiredClasses applier:(AUTThemePropertiesApplierBlock)applier
{
    NSParameterAssert(properties);
    NSParameterAssert(applier);
    self = [super init];
    if (self) {
        self.properties = properties;
        self.applier = applier;
        if (valueTransformersOrRequiredClasses) {
            NSAssert(properties.count == valueTransformersOrRequiredClasses.count, @"The `properties` array and the `valueTransformersOrRequiredClasses` array must have the same number of elements.");
            self.valueTransformersOrRequiredClasses = valueTransformersOrRequiredClasses;
        }
    }
    return self;
}

- (Class)requiredClassForPropertyAtIndex:(NSUInteger)index
{
    Class class = self.valueTransformersOrRequiredClasses[index];
    // Check for whether the passed object is of type `Class`
    if (class_isMetaClass(object_getClass(class))) {
        return class;
    }
    return nil;
}

- (NSString *)valueTransformerNameForPropertyAtIndex:(NSUInteger)index
{
    NSString *name = self.valueTransformersOrRequiredClasses[index];
    if ([name isKindOfClass:[NSString class]]) {
        return name;
    }
    return nil;
}

#pragma mark - AUTThemePropertiesApplier <AUTThemeApplier>

- (void)applyClass:(AUTThemeClass *)class fromTheme:(AUTTheme *)theme toObject:(id)object
{
    NSParameterAssert(class);
    NSParameterAssert(theme);
    NSParameterAssert(object);
    
    NSMutableDictionary *valuesForProperties = [NSMutableDictionary new];
    
    [self.properties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger propertyIndex, BOOL *stop) {
        
        AUTThemeConstant *constant = class.resolvedPropertiesConstants[property];
        
        Class requiredClass = [self requiredClassForPropertyAtIndex:propertyIndex];
        NSString *valueTransformerName = [self valueTransformerNameForPropertyAtIndex:propertyIndex];
        id value = [AUTThemePropertyApplier valueFromConstant:constant forProperty:property onObject:object withRequiredClass:requiredClass valueTransformerName:valueTransformerName];
        
        valuesForProperties[property] = value;
    }];
    
    self.applier([valuesForProperties copy], object);
}

- (BOOL)shouldApplyClass:(AUTThemeClass *)class
{
    NSSet *classProperties = [NSSet setWithArray:class.properties.allKeys];
    NSSet *applierProperties = [NSSet setWithArray:self.properties];
    return [classProperties intersectsSet:applierProperties];
}

@end
