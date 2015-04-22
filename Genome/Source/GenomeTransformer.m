//
//  GenomeTransformer.m
//
//  Created by Logan Wright on 2/18/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GenomeTransformer.h"

@implementation GenomeTransformer

+ (id)transformFromJsonValue:(id)fromVal {
    @throw [NSException exceptionWithName:@"Transform"
                                   reason:@"Must be overriden by subclass!"
                                 userInfo:nil];
}

+ (id)transformFromJsonValue:(id)fromJsonValue inResponseContext:(id)responseContext {
    // If this is overridden, it should not run.  If it is not overridden, call standard transform in subclass.
    return [self transformFromJsonValue:fromJsonValue];
}

+ (id)transformToJsonValue:(id)fromVal {
    // Not all operations need to be reversed, if that's the case, just return the raw value.
    return fromVal;
}

@end
