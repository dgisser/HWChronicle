//
//  PictureTableViewCell.h
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImage *pic;
@property (assign) int picWidth;
@property (assign) int picHeight;

@end