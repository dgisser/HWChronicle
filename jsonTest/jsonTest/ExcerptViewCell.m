//
//  ExcerptViewCell.m
//  theChronicle
//
//  Created by David Gisser on 1/31/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "ExcerptViewCell.h"
#import "StoriesSingleton.h"
#import "LabelMaker.h"
#import "NSString+HTML.h"

@implementation ExcerptViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.excerpt == NULL) {
            return self;
        }
        UILabel *label = [UILabel makeLabel: @"Verdana" indent:0 text:[self.excerpt stringByConvertingHTMLToPlainText] textSize:12 aboveHeight:self.height width:290];
        label.textColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1.0f];
        self.height = label.bounds.size.height;
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
