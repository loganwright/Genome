//
//  NSMutableDictionary+Genome.m
//  Genome
//
//  Created by Logan Wright on 4/4/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "NSMutableDictionary+GenomeMapping.h"

@implementation NSMutableDictionary (GenomeMapping)

+ (NSMutableDictionary *)gm_mappableDictionaryForKeyPaths:(NSArray *)keyPaths {
    NSMutableDictionary *mappableDictionary = [NSMutableDictionary dictionary];
    for (NSString *keyPath in keyPaths) {
        [mappableDictionary gm_ensureKeyPathExists:keyPath];
    }
    return mappableDictionary;
}

- (void)gm_ensureKeyPathExists:(NSString *)keyPath {
    NSArray *pathComponents = [keyPath componentsSeparatedByString:@"."];
    if (pathComponents.count > 1) {
        NSUInteger lastIdx = pathComponents.count - 1;
        NSMutableString *path = [NSMutableString string];
        // The last idx is an actual key, no need to create a path component (notice < lastIdx instead of <= lastIdx)
        for (int i = 0; i < lastIdx; i++) {
            [path appendFormat:@"%@%@", i == 0 ? @"" : @".", pathComponents[i]];
            [self gm_addDictionaryAtKeyPath:path];
        }
    }
}

- (void)gm_addDictionaryAtKeyPath:(NSString *)keyPath {
    if (![self valueForKeyPath:keyPath]) {
        [self setValue:[NSMutableDictionary dictionary] forKeyPath:keyPath];
    }
}

@end
