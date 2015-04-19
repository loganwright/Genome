//
//  NSArray+Genome.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSArray+GenomeMapping.h"
#import "NSObject+GenomeMapping.h"
#import "GenomeObject.h"

@implementation NSArray (GenomeMapping)

- (NSArray *)gm_mapToGenomeObjectClass:(Class)classForMap {
    return [self gm_mapToGenomeObjectClass:classForMap inResponseContext:nil];
}

- (NSArray *)gm_mapToGenomeObjectClass:(Class)classForMap inResponseContext:(id)responseContext {
    [self assertClassIsMappable:classForMap];
    
    NSMutableArray *mapped = [NSMutableArray array];
    for (NSDictionary *rawObject in self) {
        id mappedObject = [classForMap gm_mappedObjectWithJsonRepresentation:rawObject inResponseContext:responseContext];
        [mapped addObject:mappedObject];
    }
    return [NSArray arrayWithArray:mapped];
}

- (NSArray *)gm_mapToJSONRepresentation {
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (id ob in self) {
        if ([ob conformsToProtocol:@protocol(GenomeObject)]) {
            [jsonArray addObject:[ob gm_jsonRepresentation]];
        } else {
            [jsonArray addObject:ob];
        }
    }
    return [NSArray arrayWithArray:jsonArray];
}

/*!
 *  Used to assert that mapping is being respected
 *
 *  @param classForMap the class in question
 */
- (void)assertClassIsMappable:(Class)classForMap {
    NSAssert([classForMap conformsToProtocol:@protocol(GenomeObject)],
             @"This method requires a class that conforms to JSONMappableObject!");
}

@end
