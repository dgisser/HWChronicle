//
//  StoriesSingleton.m
//  jsonTest
//
//  Created by David Gisser on 9/9/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "StoriesSingleton.h"
#import "StoryUnzipper.h"
#import "AFHTTPRequestOperation.h"
#import "StoriesSingleton.h"
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "PersistentDictionary.h"

@interface StoriesSingleton ()

@end

@implementation StoriesSingleton

+ (StoriesSingleton *)sharedSingleton
{
    static StoriesSingleton *sharedSingleton;
    
    {
        if (!sharedSingleton)
            sharedSingleton = [[StoriesSingleton alloc] init];
        return sharedSingleton;
    }
}

-(id)init{
    if ((self = [super init])) {
        self.NewsStories = [NSMutableArray array];
        self.News1 = [NSMutableArray array];
        self.News2 = [NSMutableArray array];
        self.moreNews = [NSMutableArray array];
        self.FeaturesStories = [NSMutableArray array];
        self.moreFeatures = [NSMutableArray array];
        self.SportsStories = [NSMutableArray array];
        self.Sports1 = [NSMutableArray array];
        self.Sports2 = [NSMutableArray array];
        self.moreSports = [NSMutableArray array];
        self.TopStories = [NSMutableArray array];
        self.Top1 = [NSMutableArray array];
        self.Top2 = [NSMutableArray array];
        self.Top3 = [NSMutableArray array];
        self.moreTop = [NSMutableArray array];
        self.opinion = [NSMutableArray array];
        self.Opinion1 = [NSMutableArray array];
        self.Opinion2 = [NSMutableArray array];
        self.moreOpinion = [NSMutableArray array];
        self.Videos = [NSMutableArray array];
        self.moreVideos = [NSMutableArray array];
        self.Photos = [NSMutableArray array];
        self.morePhotos = [NSMutableArray array];
        self.Search = [NSMutableArray array];
        self.moreSearch = [NSMutableArray array];
        NSArray *keys = [NSArray arrayWithObjects:@"amount", @"capacity", @"page", nil];
        NSArray *objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:10], [[NSNumber alloc] initWithInt:1], nil];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.featuresCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:10], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.videosCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:7], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.topCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:7], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.opinionCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:7], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.photosCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:14], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.sportsCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        self.newsCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        objects = [NSArray arrayWithObjects:[[NSNumber alloc] initWithInt:0],[[NSNumber alloc] initWithInt:10], [[NSNumber alloc] initWithInt:1], nil];
        dictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
        self.searchCount = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
    return self;
}

- (void)getJSON:(NSString *)type :(BOOL)reload :(BOOL)nextPage
{
    /*NSURL *baseURL = [NSURL URLWithString:@"http://hwchronicle.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    [manager.reachabilityManager startMonitoring];
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [[StoriesSingleton sharedSingleton].contentTableController.button setTitle:@"Waiting for Internet..."];
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];*/
    
    NSArray *URLs = [[NSArray alloc] init];
    NSMutableArray *current;
    NSMutableDictionary *count;
    NSMutableArray *more;
    if ([type isEqualToString:@"Saved"]) {
        PersistentDictionary *ids = [PersistentDictionary dictionaryWithName:@"ids"];
        NSMutableArray *stories = [[NSMutableArray alloc] init];
        for (NSString* theId in ((NSMutableArray*)[ids.dictionary objectForKey:@"ids"])) {
            PersistentDictionary *astory = [PersistentDictionary dictionaryWithName:theId];
            StoryUnzipper *theStory = [[StoryUnzipper alloc] initWithDictionary:[astory.dictionary objectForKey:theId]];
            [stories addObject:theStory];
        }
        [self.contentTableController loaded:stories type:type reload:FALSE];
        return;
    }
    if([type isEqualToString:@"Search"] && self.contentTableController.searchURL == NULL && reload == FALSE){
        NSMutableArray *stories = [[NSMutableArray alloc] init];
        [self.contentTableController loaded:stories type:type reload:FALSE];
        return;
    }
    if ([type isEqualToString:@"News"]) {
        URLs = @[@"http://www.hwchronicle.com/news_importance/section_slider/?json=get_recent_posts&count=10",@"http://www.hwchronicle.com/news/?json=get_recent_posts&count=4"];
        count = self.newsCount;
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/news_importance/section_slider/?json=get_recent_posts&count=14&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        current = self.NewsStories;
        more = self.moreNews;
    }else if ([type isEqualToString:@"Features"]){
        URLs = @[@"http://www.hwchronicle.com/features_importance/section_slider/?json=get_recent_posts&count=10"];
        count = self.featuresCount;
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/features_importance/section_slider/?json=get_recent_posts&count=10&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        current = self.FeaturesStories;
        more = self.moreFeatures;
    }else if ([type isEqualToString:@"Sports"]){
        count = self.sportsCount;
        if (reload)
            self.SportsStories = [NSMutableArray array];
        URLs = @[@"http://www.hwchronicle.com/sports_importance/section_slider/?json=get_recent_posts&count=10",@"http://www.hwchronicle.com/sports/?json=get_recent_posts&count=4"];
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/sports_importance/section_slider/?json=get_recent_posts&count=14&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        current = self.SportsStories;
        more = self.moreSports;
    }else if ([type isEqualToString:@"Opinion"]){
        count = self.opinionCount;
        if (reload)
            self.opinion = [NSMutableArray array];
        URLs = @[@"http://www.hwchronicle.com/opinion_type/editorial/?json=get_recent_posts&count=2",@"http://www.hwchronicle.com/opinion_type/column/?json=get_recent_posts&count=5"];
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/opinion_type/column/?json=get_recent_posts&count=7&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        current = self.opinion;
        more = self.moreOpinion;
    }else if ([type isEqualToString:@"Gallery"]){
        URLs = @[@"http://www.hwchronicle.com/photo/?json=get_recent_posts&count=7"];
        current = self.Photos;
        count = self.photosCount;
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/photo/?json=get_recent_posts&count=10&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        more = self.morePhotos;
    }else if ([type isEqualToString:@"Top"]){
        if(reload)
            self.TopStories = [NSMutableArray array];
        current = self.TopStories;
        count = self.topCount;
        URLs = @[@"http://www.hwchronicle.com/front/center/?json=get_recent_posts&count=1",@"http://www.hwchronicle.com/front/top/?json=get_recent_posts&count=4",@"http://www.hwchronicle.com/features_importance/section_slider/?json=get_recent_posts&count=2"];
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/front/top/?json=get_recent_posts&count=7&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        more = self.moreTop;
    }else if ([type isEqualToString:@"Video"]){
        URLs = @[@"http://www.hwchronicle.com/video/?json=get_recent_posts&count=10"];
        current = self.Videos;
        more = self.moreVideos;
        count = self.videosCount;
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"http://www.hwchronicle.com/video/?json=get_recent_posts&count=10&page=%d",((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
    }else if ([type isEqualToString:@"Search"]){
        URLs = @[self.contentTableController.searchURL];
        current = self.Search;
        count = self.searchCount;
        if (nextPage)
            URLs = @[[NSString stringWithFormat:@"%@&page=%d",self.contentTableController.searchURL,((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)]];
        more = self.moreSearch;
    }
    if (reload){
        [current removeAllObjects];
        [count setValue:[[NSNumber alloc] initWithInt:0] forKey:@"amount"];
        if (![type isEqualToString:@"Video"])
            [count setValue:[[NSNumber alloc] initWithInt:1] forKey:@"page"];
        else
            [count setValue:[[NSNumber alloc] initWithInt:1] forKey:@"page"];
    }
    if ([current count] > 0 && !reload && !nextPage) {
        [self.contentTableController loaded:current type:type reload:FALSE];
        return;
    }
    if (nextPage) {
        NSURL *Url = [NSURL URLWithString:[URLs objectAtIndex:0]];
        NSURLRequest *Request = [NSURLRequest requestWithURL:Url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                             initWithRequest:Request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
            [count setValue:[[NSNumber alloc] initWithInt:0] forKey:@"amount"];
            [count setValue:[[NSNumber alloc] initWithInt:((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]+1)] forKey:@"page"];
            [more removeAllObjects];
            NSArray* posts = [(NSDictionary *)JSON objectForKey:@"posts"];
            if ([posts count] == 0){
                [self.contentTableController loaded:current type:type reload:TRUE];
                [count setObject:[[NSNumber alloc] initWithInt:((int)[((NSNumber*)([count objectForKey:@"page"])) integerValue]-1)] forKey:@"page"];
                return;
            }
            if ([posts count] < [((NSNumber*)[count objectForKey:@"capacity"]) intValue])
                [count setValue:[[NSNumber alloc] initWithInt:(int)[posts count]] forKey:@"capacity"];
            for (int loop = 0; (loop < [posts count]) && loop < [((NSNumber*)[count objectForKey:@"capacity"]) intValue]; loop++) {
                NSDictionary *one = posts[loop];
                StoryUnzipper *story = [[StoryUnzipper alloc] init];
                [more addObject:story];
                [story makeStory:one withCount:count withStories:more type:type current:current];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[StoriesSingleton sharedSingleton].contentTableController.button setTitle:@"No Connection..." forState:UIControlStateDisabled];
        }];
        [operation start];
        return;
    }
    for (NSString *URL in URLs) {
        if ([URL  isEqual: @"http://www.hwchronicle.com/front/center/?json=get_recent_posts&count=1"])
            current = self.Top1;
        else if([URL  isEqual: @"http://www.hwchronicle.com/front/top/?json=get_recent_posts&count=4"])
            current = self.Top2;
        else if([URL  isEqual: @"http://www.hwchronicle.com/features_importance/section_slider/?json=get_recent_posts&count=2"])
            current = self.Top3;
        else if([URL  isEqual: @"http://www.hwchronicle.com/opinion_type/editorial/?json=get_recent_posts&count=2"])
            current = self.Opinion1;
        else if([URL  isEqual: @"http://www.hwchronicle.com/opinion_type/column/?json=get_recent_posts&count=5"])
            current = self.Opinion2;
        else if([URL  isEqual: @"http://www.hwchronicle.com/sports/?json=get_recent_posts&count=4"])
            current = self.Sports1;
        else if([URL  isEqual: @"http://www.hwchronicle.com/sports_importance/section_slider/?json=get_recent_posts&count=10"])
            current = self.Sports2;
        else if([URL  isEqual: @"http://www.hwchronicle.com/news/?json=get_recent_posts&count=4"])
            current = self.News1;
        else if([URL  isEqual: @"http://www.hwchronicle.com/news_importance/section_slider/?json=get_recent_posts&count=10"])
            current = self.News2;
        [current removeAllObjects];
        NSURL *Url = [NSURL URLWithString:URL];
        NSURLRequest *Request = [NSURLRequest requestWithURL:Url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                             initWithRequest:Request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
            NSArray* posts = [(NSDictionary *)JSON objectForKey:@"posts"];
            if ([posts count] == 0)
                [self.contentTableController loaded:current type:type reload:FALSE];
            if ([type isEqualToString:@"Search"] && [posts count] < 10)
                [count setValue:[[NSNumber alloc] initWithInt:(int)[posts count]] forKey:@"capacity"];
            else if ([type isEqualToString:@"Search"])
                [count setValue:[[NSNumber alloc] initWithInt:10] forKey:@"capacity"];
            for (int loop = 0; (loop < [posts count]) && loop < [((NSNumber*)[count objectForKey:@"capacity"]) intValue]; loop++) {
                NSDictionary *one = posts[loop];
                StoryUnzipper *story = [[StoryUnzipper alloc] init];
                [current addObject:story];
                [story makeStory:one withCount:count withStories:current type:type current:NULL];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[StoriesSingleton sharedSingleton].contentTableController.button setTitle:@"No Connection..." forState:UIControlStateDisabled];
        }];
        [operation start];
    }
}

@end
