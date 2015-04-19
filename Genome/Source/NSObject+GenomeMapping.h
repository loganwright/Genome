//
//  NSObject+Genome.h
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Used to define the basic genome interface
 
 :returns: used alongside GenomeObject protocol to allow various base classes with ease.
 */
@interface NSObject (GenomeMapping)

#pragma mark - Mapping

/*!
 *  The initializer used to map from a Json dictionary.  If initializing objects in a Json Array, use `[NSArray mapToJSONMappableClass:]`
 *
 *  @param jsonRepresentation ...
 *
 *  @return an object initialized with the values of the JSON Representation
 */
+ (instancetype)gm_mappedObjectWithJsonRepresentation:(NSDictionary *)jsonRepresentation;

/*!
 *  The initializer used to map from a Json dictionary.  If initializing objects in a Json Array, use `[NSArray mapToJSONMappableClass:]`
 *
 *  @param jsonRepresentation ...
 *
 *  @return an object initialized with the values of the JSON Representation
 */
+ (instancetype)gm_mappedObjectWithJsonRepresentation:(NSDictionary *)jsonRepresentation
                                    inResponseContext:(id)responseContext;

#pragma mark - To Json

/*!
 *  Returns a json representation of the object
 *
 *  @return the json representation
 */
- (NSDictionary *)gm_jsonRepresentation;


#pragma mark - Instance Overrides

/*!
 *  This is provided as a means to override default initialization behavior.  For example, if you're dealing with a core data object, you may want to insert it into a managed context first.
 *
 *  @return a valid object that is ready to be mapped
 */
+ (instancetype)gm_newInstance;

/*!
 *  Use this to override default initialization behavior.
 *
 *  @param jsonRepresentation the json representation that will be mapped to the object returned from this method.  Do NOT map during this operation, mapping will happen afterwards.
 *
 *  @return a valid object that is ready to be mapped
 */
+ (instancetype)gm_newInstanceForJsonRepresentation:(NSDictionary *)jsonRepresentation;

/*!
 *  Use this to override default initialization behavior.
 *
 *  @param jsonRepresentation the json representation that will be mapped to the object returned from this method.  Do NOT map during this operation, mapping will happen afterwards.
 *  @param responseContext    the initial json payload sent to mapping.  Sub objects can access this greater mapping
 *
 *  @return a valid object that is ready to be mapped
 */
+ (instancetype)gm_newInstanceForJsonRepresentation:(NSDictionary *)jsonRepresentation inResponseContext:(id)responseContext;

#pragma mark - Debugging

/*!
 *  For debugging
 *
 *  @return returns a description of the values set given the current mapping
 */
- (NSString *)gm_mappableDescription;

@end

/*!
 *  Used as a convenience when declaring classes explicitly in a mapping
 *
 *  @param propertyName the property name or key path being used in the mapping
 *  @param classType    the class type corresponding with the property
 *
 *  @return a mapped class following the format propertyName@className
 */
NSString *gm_propertyMap(NSString *propertyName, Class classType);
