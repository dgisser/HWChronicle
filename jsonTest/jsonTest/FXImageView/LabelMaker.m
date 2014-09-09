//
//  LabelMaker.m
//  The Chronicle
//
//  Created by David Gisser on 3/2/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "LabelMaker.h"
#import "NSString+HTML.h"

@implementation UILabel (LabelMaker)

+ (UILabel*) makeLabel: (NSString*)font indent:(int)indent text:(NSString*)text textSize:(int)textSize aboveHeight:(int)aboveHeight width:(int)width{
    UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + indent, 0, width, 20)];
    theLabel.text = [text stringByDecodingHTMLEntities];
    theLabel.numberOfLines = 0;
    theLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [theLabel setFont:[UIFont fontWithName:font size:textSize]];
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = theLabel.lineBreakMode;
    CGRect textRect = [theLabel.text boundingRectWithSize:maximumLabelSize
        options:NSStringDrawingUsesLineFragmentOrigin
     attributes:@{NSFontAttributeName:theLabel.font,
                  NSParagraphStyleAttributeName: paragraphStyle.copy}
        context:nil];
    theLabel.frame = CGRectMake(15 + indent, aboveHeight, width, textRect.size.height);
    return theLabel;
}

@end
