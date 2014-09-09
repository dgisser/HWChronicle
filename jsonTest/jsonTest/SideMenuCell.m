//
//  SideMenuCell.m
//  theChronicle
//
//  Created by David Gisser on 1/29/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "SideMenuCell.h"
#import "SettingsSingleton.h"

@implementation SideMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int height;
        CGFloat screenSize = [[UIScreen mainScreen] bounds].size.height;
        if (screenSize == 480)
            height = 46;
        else
            height = 55.8;
        self.backgroundColor = [UIColor blackColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 130, 25)];
        if (self.type == NULL)
            return self;
        label.text = self.type;
        if ([self.type isEqualToString:@"Saved"])
            label.text = @"Reading List";
        if ([self.type isEqualToString:@"Top"])
            label.text = @"Front Page";
        CGRect size = CGRectMake(55, 0, 15, height);
        UIView *colorBox = [[UIView alloc] initWithFrame:size];
        if ([self.type isEqualToString:@"News"])
            colorBox.backgroundColor = [UIColor blueColor];
        else if([self.type isEqualToString:@"Sports"])
            colorBox.backgroundColor = [UIColor redColor];
        else if([self.type isEqualToString:@"Features"])
            colorBox.backgroundColor = [UIColor orangeColor];
        else if([self.type isEqualToString:@"Opinion"])
            colorBox.backgroundColor = [UIColor colorWithRed:83/255.0f green:143/255.0f blue:37/255.0f alpha:1.0f];
        else
            colorBox.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:colorBox];
        label.numberOfLines = 0;
        [label setFont:[UIFont fontWithName:[SettingsSingleton sharedSingleton].bylineFont size:22]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end