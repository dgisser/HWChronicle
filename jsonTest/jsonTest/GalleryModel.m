//
//  GalleryModel.m
//  The Chronicle
//
//  Created by David Gisser on 2/19/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "GalleryModel.h"
#import "FXImageView.h"

@implementation GalleryModel

+(GalleryModel*)makeView:(NSString*) rawCode{
    GalleryModel *model = [[GalleryModel alloc] init];
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"src=\\\"([^\"]*)" options:0 error:nil];
    NSArray *matches2 = [regex2 matchesInString:rawCode options:0 range:NSMakeRange(0, [rawCode length])];
    
    
    model.Images = [[NSMutableArray alloc] init];
    if ([matches2 count]) {
        for (NSTextCheckingResult *match in matches2) {
            NSRange matchRange = [match rangeAtIndex:1];
            NSString* URL = [rawCode substringWithRange:matchRange];
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.+?(?=-234))" options:1 error:nil];
            NSArray *matches = [regex matchesInString:URL options:0 range:NSMakeRange(0, [URL length])];
            
            NSTextCheckingResult *realmatch = [matches firstObject];
            matchRange = [realmatch rangeAtIndex:1];
            NSString* link = [URL substringWithRange:matchRange];
            
            NSRegularExpression *regex3 = [NSRegularExpression regularExpressionWithPattern:@".([^.]+)$" options:0 error:nil];
            NSArray *matches3 = [regex3 matchesInString:URL options:0 range:NSMakeRange(0, [URL length])];
            
            NSTextCheckingResult *extensionmatch = [matches3 firstObject];
            matchRange = [extensionmatch rangeAtIndex:1];
            NSString* extension = [URL substringWithRange:matchRange];
            if (![link isEqualToString:@""])
                URL = [NSString stringWithFormat:@"%@.%@",link,extension];
            FXImageView *tbd = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 290.0f, 290.0f)];
            [model.Images addObject:tbd];
            [tbd setImageWithContentsOfURL:[NSURL URLWithString:URL]];
            tbd.contentMode = UIViewContentModeScaleAspectFit;
            tbd.asynchronous = NO;
            tbd.reflectionScale = 0.5f;
            tbd.reflectionAlpha = 0.25f;
            tbd.reflectionGap = 10.0f;
            tbd.shadowOffset = CGSizeMake(0.0f, 2.0f);
            tbd.shadowBlur = 5.0f;
        }
    }
    model.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, 290)];
    model.carousel.type = iCarouselTypeRotary;
    model.carousel.dataSource = model;
    model.carousel.delegate = model;
    return model;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (view == nil)
        return self.Images[index];
    
    return view;
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.Images count];
}

@end
