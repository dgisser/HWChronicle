//
//  SportsSingleton.m
//  jsonTest
//
//  Created by David Gisser on 9/4/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "SportsSingleton.h"

@implementation SportsSingleton

+ (SportsSingleton *)sharedSingleton
{
    static SportsSingleton *sharedSingleton;
    
    {
        if (!sharedSingleton)
            sharedSingleton = [[SportsSingleton alloc] init];
        
        return sharedSingleton;
    }
}

-(id)init{
    if ((self = [super init])) {
        
        _stories = [NSMutableArray array];
        
    }
    return self;
}

@end
