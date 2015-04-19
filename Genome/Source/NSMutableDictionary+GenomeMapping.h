//
//  NSMutableDictionary+Genome.h
//  Genome
//
//  Created by Logan Wright on 4/4/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  When mapping to a Json Dictionary using keypath mappings, it must be insured that container dictionaries exist for specified paths.
 */
@interface NSMutableDictionary (GenomeMapping)

/*!
 *  If you try to set a value for keypath that doesn't exist, a noop results and the value is not set.  This ensures that all keypaths have a prepared mutable dictionary so values can be inserted.
 *
 *  For example:
 *  NSMutableDictionary *d = [NSMutableDictionary dictionary];
 *  [d setValue:@"Hello" forKeyPath:@"universe.solarsystem.world"] // d will still be empty
 *
 *  NSMutableDictionary *d = [gm_mappableDictionaryForKeyPaths:@[@"universe.solar_system.world"]];
 *  [d setValue:@"Hello" forKeyPath:@"universe.solarsystem.world"] // d will have value @"Hello" at keypath
 *
 *  @param keyPaths the keypaths to ensure existence.
 *
 *  @return a mutable dictionary that contains subdictionaries as necessary.
 */
+ (NSMutableDictionary *)gm_mappableDictionaryForKeyPaths:(NSArray *)keyPaths;

@end
