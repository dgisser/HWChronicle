//
//  MasterMainTableViewCell.m
//  theChronicle
//
//  Created by David Gisser on 1/4/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "MasterMainTableViewCell.h"
#import "StoriesSingleton.h"
#import "JFTimeFormatter.h"
#import "LabelMaker.h"
#import "NSString+HTML.h"
#import "SettingsSingleton.h"

@implementation MasterMainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float picWidth = 0.0;
        float picHeight = 0.0;
        self.heightAdded = 10;
        int indent = 0;
        UIImage *photo;
        if (self.story == NULL)
            return self;
        if ([self.story.contentType isEqualToString:@"pic"]) {
            picHeight = self.story.picHeight;
            picWidth = self.story.picWidth;
            photo = self.story.photo;
            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - picWidth)/2, 15, picWidth, picHeight) ];
            backgroundImage.image = photo;
            [self.contentView addSubview:backgroundImage];
            self.heightAdded += 20 + self.story.picHeight;
        }
        if (self.story.headShot != NULL) {
            UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(15,self.heightAdded,75,75)];
            head.image = self.story.headShot;
            [self.contentView addSubview:head];
            indent = 75;
        }
        UILabel *titleLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].titleFont indent:indent text:self.story.title textSize:18 aboveHeight:self.heightAdded width:290-indent];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        self.heightAdded += titleLabel.bounds.size.height;
        [self.contentView addSubview:titleLabel];
        
        self.heightAdded += 5;
        UILabel *bylineLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].bylineFont indent:indent text:[[NSString stringWithFormat:@"By %@",[self.story.name stringByDecodingHTMLEntities]] uppercaseString] textSize:10 aboveHeight:self.heightAdded width:200-indent];
        bylineLabel.textColor = [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1.0f];
        int bylineHeight = bylineLabel.bounds.size.height;
        bylineLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:bylineLabel];
        
        NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
        mmddccyy.timeStyle = NSDateFormatterNoStyle;
        mmddccyy.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *d = [mmddccyy dateFromString:self.story.date];
        NSString *date = [JFTimeFormatter relativeDateStringFromTime:[d timeIntervalSince1970]];
        UILabel *dateLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].bylineFont indent:195 text:[date uppercaseString] textSize:10 aboveHeight:self.heightAdded width:90];
        dateLabel.textColor = [UIColor colorWithRed:144/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        dateLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:dateLabel];
        if (dateLabel.bounds.size.height > bylineHeight)
            self.heightAdded += dateLabel.bounds.size.height + 5;
        else
            self.heightAdded += bylineHeight + 5;
        
        UILabel *excerptLabel = [UILabel makeLabel: [SettingsSingleton sharedSingleton].excerptFont indent:indent text:[self.story.excerpt stringByConvertingHTMLToPlainText] textSize:12 aboveHeight:self.heightAdded width:290-indent];
        excerptLabel.textColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1.0f];
        excerptLabel.textAlignment=NSTextAlignmentJustified;
        self.heightAdded += excerptLabel.bounds.size.height + 5;
        [self.contentView addSubview:excerptLabel];
        if (self.heightAdded - self.story.picHeight <= 75 && self.story.headShot != NULL)
            self.heightAdded = 75 + self.story.picHeight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
