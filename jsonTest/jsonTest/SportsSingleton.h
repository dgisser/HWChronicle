//
//  SportsSingleton.h
//  jsonTest
//
//  Created by David Gisser on 9/4/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsSingleton : NSObject
+ (SportsSingleton *)sharedSingleton;
@property (strong, nonatomic) NSMutableArray *stories;

@end
