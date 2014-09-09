//
//  LabelMaker.h
//  The Chronicle
//
//  Created by David Gisser on 3/2/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelMaker)

+ (UILabel*) makeLabel: (NSString*)font indent:(int)indent text:(NSString*)text textSize:(int)textSize aboveHeight:(int)aboveHeight width:(int)width;

@end
