//
//  AUTTheme.m
//  AUTTheming
//
//  Created by Eric Horacek on 12/22/14.
//  Copyright (c) 2014 Automatic Labs, Inc. All rights reserved.
//

#import "AUTTheme.h"
#import "AUTTheme_Private.h"
#import "AUTThemeClass_Private.h"
#import "AUTThemeClass.h"
#import "AUTThemeConstant.h"
#import "AUTThemeConstant_Private.h"
#import "AUTThemeParser.h"
#import "NSURL+ThemeNaming.h"

NSString * const AUTThemingErrorDomain = @"com.automatic.AUTTheming";

@implementation AUTTheme

#pragma mark - NSObject

- (instancetype)init {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    // Ensure that exception is thrown when just `init` is called.
    self = [self initWithJSONFile:nil error:NULL];
#pragma clang diagnostic pop
    return self;
}

#pragma mark - AUTTheme

#pragma mark Public

+ (instancetype)themeFromJSONThemeNamed:(NSString *)themeName error:(NSError *__autoreleasing *)error {
    NSParameterAssert(themeName);
    
    return [self themeFromJSONThemesNamed:@[themeName] error:error];
}

+ (instancetype)themeFromJSONThemesNamed:(NSArray *)themeNames error:(NSError *__autoreleasing *)error {
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    return [self themeFromJSONThemesNamed:themeNames bundle:nil error:error];
}

+ (instancetype)themeFromJSONThemesNamed:(NSArray *)themeNames bundle:(NSBundle *)bundle error:(NSError *__autoreleasing *)error {
    NSParameterAssert(themeNames);
    NSAssert(themeNames.count > 0, @"Must provide at least one theme name");
    
    // Build an array of URLs from the specified theme names
    NSArray *fileURLs = [NSURL
        aut_fileURLsFromThemeNames:themeNames
        inBundle:bundle];
    
    return [[AUTTheme alloc] initWithJSONFiles:fileURLs error:error];
}

- (instancetype)initWithJSONFile:(NSURL *)fileURL error:(NSError **)error; {
    NSParameterAssert(fileURL);
    
    return [self initWithJSONFiles:@[fileURL] error:error];
}

- (instancetype)initWithJSONFiles:(NSArray *)fileURLs error:(NSError *__autoreleasing *)error {
    NSParameterAssert(fileURLs);
    NSAssert(fileURLs.count > 0, @"Must provide at least one file URL");
    
    NSMutableArray *themeDictionaries = [NSMutableArray new];
    NSMutableArray *validFileURLs = [NSMutableArray new];
    
    for (NSURL *fileURL in fileURLs) {
        NSDictionary *themeDictionary = [self.class
            themeDictionaryFromJSONFileURL:fileURL error:error];
        if (themeDictionary) {
            [themeDictionaries addObject:themeDictionary];
            [validFileURLs addObject:fileURL];
        }
    }
    
    NSAssert(
        (themeDictionaries.count > 0),
        @"None of the specified JSON theme files at the following URLs "
            "contained valid themes %@. Error %@",
        fileURLs,
        (error ? *error : nil));
    
    self = [self initWithThemeDictionaries:themeDictionaries error:error];
    if (self) {
        for (NSURL *fileURL in validFileURLs) {
            [self addFileURLsObject:fileURL];
        }
    }
    return self;
}

- (instancetype)initWithThemeDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error {
    NSParameterAssert(dictionary);
    
    return [self initWithThemeDictionaries:@[dictionary] error:error];
}

- (instancetype)initWithThemeDictionaries:(NSArray *)dictionaries error:(NSError *__autoreleasing *)error; {
    NSParameterAssert(dictionaries);
    NSAssert(
        dictionaries.count > 0,
        @"Must provide at least one theme dictionary");
    
    self = [super init];
    if (self) {
        for (NSDictionary *dictionary in dictionaries) {
            AUTThemeParser *parser = [[AUTThemeParser alloc]
                initWithRawTheme:dictionary
                inheritingFromTheme:self
                error:error];
            [self addConstantsFromDictionary:parser.parsedConstants];
            [self addClassesFromDictionary:parser.parsedClasses];
        }
    }
    return self;
}

+ (NSDictionary *)themeDictionaryFromJSONFileURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error {
    NSParameterAssert(fileURL);
    
    // If the file is not a file URL, populate the error object
    if (!fileURL.isFileURL) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The specified file URL is invalid %@",
                fileURL];
            *error = [NSError
                errorWithDomain:AUTThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }
    
    NSData *JSONData = [NSData
        dataWithContentsOfURL:fileURL
        options:0
        error:error];
    
    if (!JSONData) {
        if (error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"Unable to load contents of file at URL %@",
                fileURL];
            *error = [NSError
                errorWithDomain:AUTThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }
    
    id JSONObject = [NSJSONSerialization
        JSONObjectWithData:JSONData
        options:0
        error:error];
    
    if (![JSONObject isKindOfClass:NSDictionary.class]) {
        if (error && !*error) {
            NSString *localizedDescription = [NSString stringWithFormat:
                @"The provided JSON does not have a dictionary as the root "
                    "object. It is instead %@",
                JSONObject];
            *error = [NSError
                errorWithDomain:AUTThemingErrorDomain
                code:1
                userInfo:@{
                    NSLocalizedDescriptionKey : localizedDescription
                }];
        }
        return nil;
    }
    
    return JSONObject;
}

- (id)constantValueForKey:(NSString *)key {
    NSParameterAssert(key);
    
    return [self constantForKey:key].value;
}

- (AUTThemeClass *)classForName:(NSString *)name {
    NSParameterAssert(name);
    
    return self.classes[name];
}

- (BOOL)applyClassWithName:(NSString *)name toObject:(id)object {
    NSParameterAssert(name);
    NSParameterAssert(object);
    
    AUTThemeClass *class = [self classForName:name];
    if (!class) {
        return NO;
    }
    return [class applyToObject:object];
}

#pragma mark Private

#pragma mark Names

- (NSArray *)names {
    NSMutableArray *names = [NSMutableArray new];
    for (NSURL *fileURL in self.fileURLs) {
        [names addObject:fileURL.aut_themeName];
    }
    return [names copy];
}

#pragma mark Filenames

- (NSArray *)filenames {
    NSMutableArray *filenames = [NSMutableArray new];
    for (NSURL *fileURL in self.fileURLs) {
        [filenames addObject:fileURL.lastPathComponent];
    }
    return [filenames copy];
}

#pragma mark FileURLs

- (NSArray *)fileURLs {
    if (!_fileURLs) {
        self.fileURLs = [NSMutableArray new];
    }
    return _fileURLs;
}

- (void)addFileURLsObject:(NSURL *)fileURL {
    NSMutableSet *fileURLs = [self.fileURLs mutableCopy];
    [fileURLs addObject:fileURL];
    self.fileURLs = [fileURLs copy];
}

#pragma mark Constants

- (AUTThemeConstant *)constantForKey:(NSString *)key {
    return self.constants[key];
}

- (NSDictionary *)constants {
    if (!_constants) {
        _constants = [NSDictionary new];
    }
    return _constants;
}

- (void)addConstantsFromDictionary:(NSDictionary *)dictionary {
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary *constants = [self.constants mutableCopy];
    [constants addEntriesFromDictionary:dictionary];
    self.constants = [constants copy];
}

#pragma mark Classes

- (NSDictionary *)classes {
    if (!_classes) {
        _classes = [NSDictionary new];
    }
    return _classes;
}

- (void)addClassesFromDictionary:(NSDictionary *)dictionary {
    if (!dictionary.count) {
        return;
    }
    NSMutableDictionary *classes = [self.classes mutableCopy];
    [classes addEntriesFromDictionary:dictionary];
    self.classes = [classes copy];
}

@end
