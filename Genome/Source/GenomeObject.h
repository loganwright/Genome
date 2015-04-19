//
//  GenomeObject
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  This defines a genome operation which will either be FromJson or ToJson
 */
typedef NS_ENUM(NSUInteger, GenomeOperation){
    /*!
     *  <#Description#>
     */
    GenomeOperationFromJson,
    /*!
     *  <#Description#>
     */
    GenomeOperationToJson
};

@class NSManagedObjectContext;

@protocol GenomeObject <NSObject>

/*!
 *  How to map the object with the following format ['propertyName' : 'associatedJSONKeyPath'].  Also supports key paths, ie: ['property.path' : 'associatedJSONKeyPath'].  To map to arrays of a class, use ['arrayPropertyName@JPTypeOfClass' : 'associatedJSONKeyPath'].
 *
 *  @return the mapping defined by the user
 */
@optional + (NSDictionary *)mapping;

/*!
 *  Override this if you need a specified mapping for the operation from and to json
 */
@optional + (NSDictionary *)mappingForOperation:(GenomeOperation)operation;

/*!
 *  If nil or null is received from Json for a given key, default values will be consulted before skipping setting
 *
 *  @return the default value for a given property name.  ie: ['propertyName' : 'default value'] -- Supports key paths :)
 *  @warning Do not use @ syntax to define a class in the default values section!
 */
@optional + (NSDictionary *)defaultPropertyValues;

@end
