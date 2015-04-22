//
//  NSObject+Genome.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSObject+GenomeMapping.h"

#import "GenomeObject.h"
#import "GenomeTransformer.h"
#import "NSObject+GenomeIntrospection.h"
#import "NSArray+GenomeMapping.h"
#import "NSMutableDictionary+GenomeMapping.h"

static BOOL LOG = NO;

static NSString * const GenomeSeparatorCharacter = @"@";

@implementation NSObject (GenomeMapping)

#pragma mark - Initialization + Mapping

+ (instancetype)gm_mappedObjectWithJsonRepresentation:(NSDictionary *)jsonRepresentation {
    return [self gm_mappedObjectWithJsonRepresentation:jsonRepresentation inResponseContext:nil];
}

+ (instancetype)gm_mappedObjectWithJsonRepresentation:(NSDictionary *)jsonRepresentation inResponseContext:(id)responseContext {
    id new = [self gm_newInstanceForJsonRepresentation:jsonRepresentation inResponseContext:responseContext];
    [new gm_mapWithJSONRepresentation:jsonRepresentation inResponseContext:responseContext];
    return new;
}

#pragma mark - Mapping: From Json

- (void)gm_mapWithJSONRepresentation:(NSDictionary *)jsonRepresentation inResponseContext:(id)responseContext {
    NSDictionary *mapping = [[self class] mappingForOperation:GenomeOperationFromJson];
    NSDictionary *defaults = [[self class] defaultPropertyValues];
    for (NSString *propertyNameKey in mapping.allKeys) {
        NSString *associatedJSONKeyPath = mapping[propertyNameKey];
        id associatedValue = [jsonRepresentation valueForKeyPath:associatedJSONKeyPath];
        NSArray *components = [propertyNameKey componentsSeparatedByString:GenomeSeparatorCharacter];
        NSString *propertyNamePath = components.firstObject;
        
        if (!associatedValue || associatedValue == [NSNull null]) {
            id defaultVal = defaults[propertyNamePath];
            
            if (LOG) {
                if (defaultVal) {
                    NSLog(@"%@ : SETTING DEFAULT : %@ : propertyName: %@", NSStringFromClass([self class]), defaultVal, propertyNamePath);
                } else {
                    NSLog(@"%@ : NO VALUE OR DEFAULT FOUND : propertyName: %@", NSStringFromClass([self class]), propertyNamePath);
                }
            }
            
            if (defaultVal) {
                [self setValue:defaultVal forKeyPath:propertyNamePath];
            }
            
            continue;
        }
        
        Class mappableClass;
        Class transformerClass;
        
        // If components == 2, then the user has declared either a transformer or a mappable class in addition.
        if (components.count == 2) {
            NSString *classOrTransformer = components.lastObject;
            Class class = NSClassFromString(classOrTransformer);
            if (!class) {
                class = [self gm_possibleSwiftClassForName:classOrTransformer];
            }
            if ([class conformsToProtocol:@protocol(GenomeObject)]) {
                mappableClass = class;
            } else if ([class isSubclassOfClass:[GenomeTransformer class]]) {
                transformerClass = class;
            } else {
                NSLog(@"Unrecognized class or transformer: %@", classOrTransformer);
            }
        }
        
        // Attempt introspection
        if (!mappableClass) {
            Class propertyClass = [self gm_classForPropertyName:propertyNamePath];
            if ([propertyClass conformsToProtocol:@protocol(GenomeObject)]) {
                mappableClass = propertyClass;
            }
        }
        
        // Transformer class takes precedence.
        if (transformerClass) {
            associatedValue = [transformerClass transformFromJsonValue:associatedValue inResponseContext:responseContext];
        } else if (mappableClass) {
            if ([associatedValue isKindOfClass:[NSArray class]]) {
                associatedValue = [associatedValue gm_mapToGenomeObjectClass:mappableClass inResponseContext:responseContext];
            } else {
                associatedValue = [mappableClass gm_mappedObjectWithJsonRepresentation:associatedValue inResponseContext:responseContext];
            }
        }
        
        if (LOG) {
            NSLog(@"%@ : SETTING : val : %@ : propertyName: %@", NSStringFromClass([self class]), associatedValue, propertyNamePath);
        }
        
        [self setValue:associatedValue forKeyPath:propertyNamePath];
    }
}

#pragma mark - Mapping: To Json

- (NSDictionary *)gm_jsonRepresentation {
    NSDictionary *mapping = [[self class] mappingForOperation:GenomeOperationToJson];
    NSMutableDictionary *jsonRepresentation = [NSMutableDictionary gm_mappableDictionaryForKeyPaths:mapping.allValues];
    for (NSString *propertyNameKey in mapping.allKeys) {
        NSArray *components = [propertyNameKey componentsSeparatedByString:GenomeSeparatorCharacter];
        
        Class transformerClass;
        if (components.count == 2) {
            NSString *classString = components.lastObject;
            Class possibleTransformerClass = NSClassFromString(classString);
            if (!possibleTransformerClass) {
                // Check swift cache for namespaced class
                possibleTransformerClass = [self gm_possibleSwiftClassForName:classString];
            }
            
            if ([possibleTransformerClass isSubclassOfClass:[GenomeTransformer class]]) {
                transformerClass = possibleTransformerClass;
            } else if (LOG) {
                /*
                 It's ok that this class isn't a transformer, because it might be a mappable object class.
                 If logging is enabled, check to see that it conforms to this.
                 If it doesn't then we've been given a declaration we can't interpret.  Notify user.
                 */
                if (![possibleTransformerClass conformsToProtocol:@protocol(GenomeObject)]) {
                    NSLog(@"Unable to parse mappable class: %@ for property: %@ on object of class: %@",
                          possibleTransformerClass,
                          components.firstObject,
                          [self class]);
                }
            }
        }
        
        NSString *propertyName = components.firstObject;
        id val = [self valueForKeyPath:propertyName];
        
        if (val) {
            if (transformerClass) {
                val = [transformerClass transformToJsonValue:val];
            } else if ([val conformsToProtocol:@protocol(GenomeObject)]) {
                val = [val gm_jsonRepresentation];
            } else if ([val isKindOfClass:[NSArray class]]) {
                val = [val gm_mapToJSONRepresentation];
            }
            
            if (val) {
                NSString *jsonKeyPath = mapping[propertyNameKey];
                [jsonRepresentation setValue:val forKeyPath:jsonKeyPath];
            } else if (LOG) {
                NSLog(@"Unable to map value for property name: %@ to Json", propertyName);
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:jsonRepresentation];
}

#pragma mark - Initialization Overrides

+ (instancetype)gm_newInstance {
    return [[[self class] alloc] init];
}

+ (instancetype)gm_newInstanceForJsonRepresentation:(NSDictionary *)jsonRepresentation {
    return [self gm_newInstance];
}

+ (instancetype)gm_newInstanceForJsonRepresentation:(NSDictionary *)jsonRepresentation inResponseContext:(id)responseContext {
    return [self gm_newInstanceForJsonRepresentation:jsonRepresentation];
}

#pragma mark - Debugging

- (NSString *)gm_mappableDescription {
    NSString *descript = @"";
    // To log the other way, just print out gm_jsonRepresentation
    NSDictionary *mapping = [[self class] mappingForOperation:GenomeOperationFromJson];
    for (NSString *propertyNameKey in mapping.allKeys) {
        NSArray *components = [propertyNameKey componentsSeparatedByString:GenomeSeparatorCharacter];
        NSString *propertyName = components.firstObject;
        id val = [self valueForKeyPath:propertyName];
        descript  = [NSString stringWithFormat:@"%@ \n %@ : %@", descript, propertyName, val];
    }
    return descript;
}

#pragma mark - Mapping Overrides

/*
 These are declared to allow for calls in this class.  These will be overridden in JSONMappableObject protocol objects
 */

+ (NSDictionary *)mapping {
    @throw [NSException exceptionWithName:@"Mapping not implemented"
                                   reason:@"Must be overriden by subclass!"
                                 userInfo:nil];
}

+ (NSDictionary *)mappingForOperation:(GenomeOperation)operation {
    /*!
     *  By default, load the mapping.  This should be overriden by subclass if per operation specificity is required.
     */
    return [self mapping];
}

/*!
 *  Not necessary to implement this
 *
 *  @return the default properties to use when mapping the current class
 */
+ (NSMutableDictionary *)defaultPropertyValues {
    return nil;
}

@end

NSString *gm_propertyMap(NSString *propertyName, Class classType) {
    NSMutableString *propertyMap = [NSMutableString string];
    [propertyMap appendString:propertyName];
    if (classType) {
        [propertyMap appendString:GenomeSeparatorCharacter];
        [propertyMap appendString:NSStringFromClass(classType)];
    }
    return propertyMap;
}
