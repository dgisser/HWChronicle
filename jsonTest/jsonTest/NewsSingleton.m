//
//  NewsSingleton.m
//  jsonTest
//
//  Created by David Gisser on 9/8/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "NewsSingleton.h"

@implementation NewsSingleton

+ (NewsSingleton *)sharedSingleton
{
    static NewsSingleton *sharedSingleton;
    
    {
        if (!sharedSingleton)
            sharedSingleton = [[NewsSingleton alloc] init];
        
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
