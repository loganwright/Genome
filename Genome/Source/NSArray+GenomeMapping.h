//
//  NSArray+Genome.h
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  This category defines the mapping procedures for NSArray to convert from and to Json
 */
@interface NSArray (GenomeMapping)

/*!
 *  Map an array to a specific object class 
 *
 *  @warning - classForMap must conform to GenomeObject protocol
 *
 *  @param classForMap the class to use when mapping each object of the array
 *
 *  @return an array with modeled genome objects
 */
- (NSArray *)gm_mapToGenomeObjectClass:(Class)classForMap;

/*!
 *  Map an array to a specific object class within a specified response context
 *
 *  @warning - classForMap must conform to GenomeObject protocol
 *
 *  @param classForMap the class to use when mapping each object of the array
 *  @param responseContext the context surrounding the mapping.  For example if an array is being mapped as a property on a broader object, you will receive the outlying context.
 *
 *  @return an array with modeled genome objects
 */
- (NSArray *)gm_mapToGenomeObjectClass:(Class)classForMap inResponseContext:(id)responseContext;

/*!
 *  Reverse the mapping operation to convert an array of objects conforming to GenomeObject protocol into an array of representative Json
 *
 *  @return an array with json representations of genome objects
 */
- (NSArray *)gm_mapToJSONRepresentation;

@end
