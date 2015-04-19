//
//  NSObject+JMIntrospection.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSObject+GenomeIntrospection.h"
#import "GenomeObject.h"
#import "GenomeTransformer.h"

#import <objc/runtime.h>

/*!
 *  Contains mapping for finding Swift classes without name spaces. ie: SomeProject.SPUser can be found from SPUser
 */
static NSDictionary *swiftClassMapping = nil;

@implementation NSObject (GenomeIntrospection)

- (NSArray *)gm_propertyNames {
    NSMutableArray * propertyNames = [NSMutableArray array];
    
    // Fetch Properties
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    // Parse Out Properties
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString * propertyName = [NSString stringWithUTF8String:name];
        [propertyNames addObject:propertyName];
    }
    
    // Free our properties
    free(properties);
    
    return propertyNames;
}

- (Class)gm_classForPropertyName:(NSString *)propertyName {
    objc_property_t prop = class_getProperty([self class], propertyName.UTF8String);
    const char * attr = property_getAttributes(prop);
    NSString *attributes = [NSString stringWithUTF8String:attr];
    NSArray *components = [attributes componentsSeparatedByString:@"\""];
    Class propertyClass;
    for (NSString *component in components) {
        Class class = NSClassFromString(component);
        if (class) {
            propertyClass = class;
            break;
        } else {
            class = swiftClassMapping[component];
            if (class) {
                propertyClass = class;
                break;
            }
        }
    }
    return propertyClass;
}

- (Class)gm_possibleSwiftClassForName:(NSString *)name {
    return swiftClassMapping[name];
}

#pragma mark - Swift Class Mapping

/*
 "You should note that +load is sent separately for categories; that is, every category on a class may contain its own +load method."
 -- http://stackoverflow.com/a/13326633/2611971
 */

+ (void)load {
    swiftClassMapping = [self gm_swiftClassMapping];
}

+ (NSDictionary *)gm_swiftClassMapping {
    NSMutableDictionary *swiftClassMapping = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    Class* runtimeClasses = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        /*
         Do not try to parse out classes using `Class class = runtimeClasses[i]` as this will cause a fatal exception on some lower level classes.
         */
        NSString *className = NSStringFromClass(runtimeClasses[i]);
        NSArray *comps = [className componentsSeparatedByString:@"."];
        /*
         "Foundation" & "Swift" are system namespaces and don't need to be monitored.
         */
        if (comps.count == 2 && ![@[@"Foundation", @"Swift"] containsObject:comps.firstObject]) {
            Class class = runtimeClasses[i];
            if ([class conformsToProtocol:@protocol(GenomeObject)] || [class isSubclassOfClass:[GenomeTransformer class]]) {
                NSString *demangledClassName = comps.lastObject;
                /*
                 In the future, I'd love to support duplicate name spaces in introspection, but at the moment it is difficult to work around the system.
                 
                 For now, if you have duplicate namespaces, declare the class explicitly for properties as opposed to allowing introspection.
                 for example
                 
                 mapping["propertyName"] = "jsonKeyPath"
                 
                 might fail introspection if it is associated with duplicate classes, You're better off declaring these namespaced classes explicitly
                 
                 mapping[propertyMapping(@"propertyName", [ClassType class])] = "jsonKeyPath"
                 
                 as opposed to relying on introspection.
                 */
                if (swiftClassMapping[demangledClassName]) {
                    NSLog(@"**Warning** Duplicate declarations found for %@ -- %@ : %@", demangledClassName, NSStringFromClass(swiftClassMapping[demangledClassName]), className);
                    NSLog(@"\n Genome won't be able to appropriately introspect these classes and explicit class types must be included in the mapping \n");
                }
                swiftClassMapping[demangledClassName] = class;
            }
        }
    }
    free(runtimeClasses);
    return swiftClassMapping;
}

@end
