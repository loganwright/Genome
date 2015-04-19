//
//  GenomeTransformer
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  This is a transformer that is used when parsing Json values into models.  The most common example is an ISO8601 date string to an NSDate and vice versa
 */
@interface GenomeTransformer : NSObject

/*!
 *  When parsing json to an object, occasionally values will need to be transformed use this to describe how
 *
 *  @param fromVal the value received from json
 *
 *  @return the value to set to the object
 */
+ (id)transformFromJsonValue:(id)fromJSONValue;

/*!
 *  In some situations, particularly, side loaded responses, it is necessary to access the greater response context when parsing.
 *  Use this context to pass the initial response for aided parsing
 *
 *  @param fromJSONValue   the value received from Json
 *  @param responseContext the raw received from the response
 *
 *  @return the value to set for the given property
 */
+ (id)transformFromJsonValue:(id)fromJSONValue inResponseContext:(id)responseContext;

/*!
 *  When parsing back to json, occasionally values will need to be transformed.  use this to describe how
 *
 *  @param fromVal the value from the object
 *
 *  @return the value to set as json
 */
+ (id)transformToJSONValue:(id)fromVal;

@end
