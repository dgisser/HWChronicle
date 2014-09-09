//
//  SettingsSingleton.h
//  The Chronicle
//
//  Created by David Gisser on 3/5/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsSingleton : NSObject

@property (strong, nonatomic) NSString *titleFont;
@property (strong, nonatomic) NSString *bylineFont;
@property (strong, nonatomic) NSString *contentFont;
@property (strong, nonatomic) NSString *excerptFont;

+ (SettingsSingleton *)sharedSingleton;

@end
