//
//  BylineTableViewCell.m
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "BylineTableViewCell.h"
#import "StoriesSingleton.h"
#import "LabelMaker.h"
#import "SettingsSingleton.h"

@implementation BylineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int indent = 0;
        if (self.head != NULL) {
            UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,100,100)];
            head.image = self.head;
            [self.contentView addSubview:head];
            indent = 105;
        }
        if (self.title == NULL)
            return self;
        UILabel *titleLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].titleFont indent:indent text:self.title textSize:19 aboveHeight:self.height width:290-indent];
        self.height = titleLabel.bounds.size.height;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        self.height +=5;
        if (self.byline == NULL)
            return self;
        UILabel *label = [UILabel makeLabel: [SettingsSingleton sharedSingleton].bylineFont indent:indent text:[[NSString stringWithFormat:@"By %@", self.byline] uppercaseString] textSize:10 aboveHeight:self.height width:290-indent];
        label.textColor = [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1.0f];
        label.textAlignment=NSTextAlignmentLeft;
        self.height += label.bounds.size.height;
        [self.contentView addSubview:label];
        self.height += 2;
        UILabel *dateLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].bylineFont indent:indent text:[self.date uppercaseString] textSize:10 aboveHeight:self.height width:290-indent];
        dateLabel.textColor = [UIColor colorWithRed:144/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        dateLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:dateLabel];
        self.height += dateLabel.bounds.size.height;
        if (self.height < 100 && self.head != NULL) {
            self.height = 100;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
