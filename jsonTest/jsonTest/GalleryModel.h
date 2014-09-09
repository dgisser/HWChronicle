//
//  GalleryModel.h
//  The Chronicle
//
//  Created by David Gisser on 2/19/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCarousel.h"

@interface GalleryModel : NSObject <iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) NSMutableArray *Images;
@property (strong, nonatomic) NSString* rawCode;
@property (strong, nonatomic) iCarousel *carousel;

+(GalleryModel*)makeView:(NSString*) rawCode;

@end
