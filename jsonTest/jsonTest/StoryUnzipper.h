//
//  StoryUnzipper.h
//  jsonTest
//
//  Created by David Gisser on 9/7/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StoryUnzipper : NSObject

-(void)makeStory:(NSDictionary *)post withCount:(NSMutableDictionary*)count withStories:(NSMutableArray*)array type:(NSString *)sectionType current:(NSMutableArray*)current;
@property (strong, nonatomic) UIImage *photo;
@property (strong, nonatomic) UIImage *headShot;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *excerpt;
@property (strong, nonatomic) NSString *idnum;
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *type;
@property (assign) int picWidth;
@property (assign) int picHeight;
@property (assign) BOOL hitThis;

-(NSDictionary*)dictionaryValue;
-(id)initWithDictionary:(NSDictionary*)dic;
-(void)concatOpinion;
-(void)concatNews;
-(void)concatSports;
-(void)concatTop;

@end
