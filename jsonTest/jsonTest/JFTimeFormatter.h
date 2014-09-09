//
//  JFTimeFormatter.h
//  LoudTap
//
//  Created by Jason Fieldman on 11/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFTimeFormatter : NSObject {

}

+ (NSString*) relativeDateStringFromTime:(uint64_t)t;
+ (NSString*) relativeDateShortStringFromTime:(uint64_t)t;

@end
