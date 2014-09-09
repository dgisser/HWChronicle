//
//  BylineTableViewCell.h
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BylineTableViewCell : UITableViewCell

@property (assign) float height;
@property (strong, nonatomic) UIImage *head;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *byline;
@property (strong, nonatomic) NSString *date;

@end
