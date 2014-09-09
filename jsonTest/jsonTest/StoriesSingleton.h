//
//  StoriesSingleton.h
//  jsonTest
//
//  Created by David Gisser on 9/9/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryUnzipper.h"
#import "StoryViewController.h"
#import "ContentTableController.h"
#import "PKRevealController.h"

@interface StoriesSingleton : NSObject
+ (StoriesSingleton *)sharedSingleton;
- (void)getJSON:(NSString *)type :(BOOL)reload :(BOOL)nextPage;
@property (strong, nonatomic) NSMutableArray *FeaturesStories;
@property (strong, nonatomic) NSMutableArray *moreFeatures;
@property (strong, nonatomic) NSMutableArray *NewsStories;
@property (strong, nonatomic) NSMutableArray *News1;
@property (strong, nonatomic) NSMutableArray *News2;
@property (strong, nonatomic) NSMutableArray *moreNews;
@property (strong, nonatomic) NSMutableArray *SportsStories;
@property (strong, nonatomic) NSMutableArray *Sports1;
@property (strong, nonatomic) NSMutableArray *Sports2;
@property (strong, nonatomic) NSMutableArray *moreSports;
@property (strong, nonatomic) NSMutableArray *TopStories;
@property (strong, nonatomic) NSMutableArray *Top1;
@property (strong, nonatomic) NSMutableArray *Top2;
@property (strong, nonatomic) NSMutableArray *Top3;
@property (strong, nonatomic) NSMutableArray *moreTop;
@property (strong, nonatomic) NSMutableArray *opinion;
@property (strong, nonatomic) NSMutableArray *Opinion1;
@property (strong, nonatomic) NSMutableArray *Opinion2;
@property (strong, nonatomic) NSMutableArray *moreOpinion;
@property (strong, nonatomic) NSMutableArray *Videos;
@property (strong, nonatomic) NSMutableArray *moreVideos;
@property (strong, nonatomic) NSMutableArray *Photos;
@property (strong, nonatomic) NSMutableArray *morePhotos;
@property (strong, nonatomic) NSMutableArray *Search;
@property (strong, nonatomic) NSMutableArray *moreSearch;
@property (weak, nonatomic) StoryViewController *storyViewController;
@property (weak, nonatomic) ContentTableController *contentTableController;
@property (weak, nonatomic) PKRevealController *pkRevealController;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableDictionary *newsCount;
@property (strong, nonatomic) NSMutableDictionary *sportsCount;
@property (strong, nonatomic) NSMutableDictionary *topCount;
@property (strong, nonatomic) NSMutableDictionary *featuresCount;
@property (strong, nonatomic) NSMutableDictionary *opinionCount;
@property (strong, nonatomic) NSMutableDictionary *videosCount;
@property (strong, nonatomic) NSMutableDictionary *photosCount;
@property (strong, nonatomic) NSMutableDictionary *searchCount;

@end