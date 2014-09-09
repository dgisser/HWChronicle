//
//  MasterMainTableViewCell.h
//  theChronicle
//
//  Created by David Gisser on 1/4/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryUnzipper.h"

@interface MasterMainTableViewCell : UITableViewCell

@property (strong, nonatomic) StoryUnzipper *story;
@property (assign) float heightAdded;

@end