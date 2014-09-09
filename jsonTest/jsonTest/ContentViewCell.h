//
//  ContentViewCell.h
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryModel.h"

@interface ContentViewCell : UITableViewCell <UIWebViewDelegate, UIScrollViewDelegate>

@property (assign) float height;
@property (assign) BOOL isVideo;
@property (assign) BOOL isGallery;
@property (strong, nonatomic) NSString* story;
@property (nonatomic, strong) GalleryModel *gallery;
@property (nonatomic, assign) NSInteger lastContentOffset;

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
} ScrollDirection;

@end
