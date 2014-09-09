//
//  NewsSingleton.h
//  jsonTest
//
//  Created by David Gisser on 9/8/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsSingleton : NSObject

+ (NewsSingleton *)sharedSingleton;
@property (strong, nonatomic) NSMutableArray *stories;

@end
