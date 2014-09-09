//
//  SettingsSingleton.m
//  The Chronicle
//
//  Created by David Gisser on 3/5/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "SettingsSingleton.h"

@implementation SettingsSingleton

+ (SettingsSingleton *)sharedSingleton
{
    static SettingsSingleton *sharedSingleton;
    
    {
        if (!sharedSingleton)
            sharedSingleton = [[SettingsSingleton alloc] init];
        return sharedSingleton;
    }
}

-(id)init{
    if ((self = [super init])) {
        self.titleFont = @"Palatino-Bold";
        self.bylineFont = @"Helvetica";
        self.contentFont = @"Georgia";
        self.excerptFont = @"Verdana";
    }
    return self;
}

@end
