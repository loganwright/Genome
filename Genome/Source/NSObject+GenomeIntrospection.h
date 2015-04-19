//
//  NSObject+JMIntrospection.h
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  This is used for introspection against an object
 */
@interface NSObject (GenomeIntrospection)

/*!
 *  An array of the property names associated with the given class
 *
 *  @return array of property names
 */
- (NSArray *)gm_propertyNames;

/*!
 *  Fetch class type
 *
 *  @param propertyName the property name to find a class for
 *
 *  @return the class associated with the given propertyName
 */
- (Class)gm_classForPropertyName:(NSString *)propertyName;

/*!
 *  Used to get swift classes outside of their namespace
 *
 *  @param name the name given in a description, like `property@SomeClass`
 *
 *  @return a class or nil
 */
- (Class)gm_possibleSwiftClassForName:(NSString *)name;

/*!
 *
 *  @return An array of all available classes within the project
 */
+ (NSDictionary *)gm_swiftClassMapping;

@end
