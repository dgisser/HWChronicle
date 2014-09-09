//
//  PictureTableViewCell.m
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "StoriesSingleton.h"

@implementation PictureTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.pic == NULL)
            return self;
        UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - self.picWidth)/2, 15, self.picWidth, self.picHeight)];
        backgroundImage.image = self.pic;
        [self.contentView addSubview:backgroundImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end