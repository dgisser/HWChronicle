//
//  StoryUnzipper.m
//  jsonTest
//
//  Created by David Gisser on 9/7/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "StoryUnzipper.h"
#import "AFHTTPRequestOperation.h"
#import "StoriesSingleton.h"
#import "UIImageView+AFNetworking.h"

@implementation StoryUnzipper

-(void)makeStory:(NSDictionary *)post withCount:(NSMutableDictionary*)count withStories:(NSMutableArray*)array type:(NSString *)sectionType current:(NSMutableArray*)current
{
    self.hitThis = FALSE;
    self.name = [post valueForKeyPath:@"author.name"];
    self.content = post[@"content"];
    self.url = post[@"url"];
    self.title = post[@"title"];
    self.excerpt = post[@"excerpt"];
    self.idnum = [NSString stringWithFormat:@"%d", [((NSNumber*)(post[@"id"])) intValue]];
    self.type = post[@"type"];
    self.type = [self.type stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.type substringToIndex:1] uppercaseString]];
    self.date = post[@"date"];
    if (post[@"thumbnail_images"] == NULL || [post[@"thumbnail_images"] count] == 0) {
        self.contentType = @"nopic";
        if (self.hitThis == TRUE || (array != [StoriesSingleton sharedSingleton].Opinion2 && array != [StoriesSingleton sharedSingleton].moreOpinion))
            [count setObject:[[NSNumber alloc] initWithInt:((int)[[count objectForKey:@"amount"] integerValue])+1] forKey:@"amount"];
        self.hitThis = TRUE;
        if ([[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue]) {
            if (current != NULL && (array != [StoriesSingleton sharedSingleton].moreOpinion || (array == [StoriesSingleton sharedSingleton].moreOpinion && self.hitThis == TRUE))) {
                [current addObjectsFromArray:array];
                [[StoriesSingleton sharedSingleton].contentTableController loaded:current type:sectionType reload:TRUE];
            }
            else if (array == [StoriesSingleton sharedSingleton].Top1 || array == [StoriesSingleton sharedSingleton].Top2 || array == [StoriesSingleton sharedSingleton].Top3)
                [self concatTop];
            else if(array == [StoriesSingleton sharedSingleton].Opinion1 || (array == [StoriesSingleton sharedSingleton].Opinion2 && (self.hitThis == TRUE)))
                [self concatOpinion];
            else if (array == [StoriesSingleton sharedSingleton].Sports1 || array == [StoriesSingleton sharedSingleton].Sports2)
                [self concatSports];
            else if (array == [StoriesSingleton sharedSingleton].News1 || array == [StoriesSingleton sharedSingleton].News2)
                [self concatNews];
            else
                [[StoriesSingleton sharedSingleton].contentTableController loaded:array type:sectionType reload:current != NULL];
        }
    } else {
        self.contentType = @"pic";
        NSString* url = [post valueForKeyPath:@"thumbnail_images.medium.url"];
        self.picWidth = 290;
        self.picHeight = ( 290 * [(NSString *)[post valueForKeyPath:@"thumbnail_images.medium.height"] intValue])/ [(NSString *)[post valueForKeyPath:@"thumbnail_images.medium.width"] intValue];
        if (self.picHeight > 250) {
            self.picHeight = 250;
            self.picWidth = ([(NSString *)[post valueForKeyPath:@"thumbnail_images.medium.width"] intValue] * 250) / [(NSString *)[post valueForKeyPath:@"thumbnail_images.medium.height"] intValue];
        }
        NSURLRequest *ImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                             initWithRequest:ImageRequest];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id pic) {
            self.photo = pic;
            if (self.hitThis == TRUE || (array != [StoriesSingleton sharedSingleton].Opinion2 && array != [StoriesSingleton sharedSingleton].moreOpinion))
                [count setObject:[[NSNumber alloc] initWithInt:((int)[[count objectForKey:@"amount"] integerValue]) + 1] forKey:@"amount"];
            self.hitThis = TRUE;
            if ([[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue]) {
                if (current != NULL && (array != [StoriesSingleton sharedSingleton].moreOpinion || (array == [StoriesSingleton sharedSingleton].moreOpinion && self.hitThis == TRUE))) {
                    [current addObjectsFromArray:array];
                    [[StoriesSingleton sharedSingleton].contentTableController loaded:current type:sectionType reload:TRUE];
                }
                else if (array == [StoriesSingleton sharedSingleton].Top1 || array == [StoriesSingleton sharedSingleton].Top2 || array == [StoriesSingleton sharedSingleton].Top3)
                    [self concatTop];
                else if(array == [StoriesSingleton sharedSingleton].Opinion1 || (array == [StoriesSingleton sharedSingleton].Opinion2 && (self.hitThis == TRUE)))
                    [self concatOpinion];
                else if (array == [StoriesSingleton sharedSingleton].Sports1 || array == [StoriesSingleton sharedSingleton].Sports2)
                    [self concatSports];
                else if (array == [StoriesSingleton sharedSingleton].News1 || array == [StoriesSingleton sharedSingleton].News2)
                    [self concatNews];
                else
                    [[StoriesSingleton sharedSingleton].contentTableController loaded:array type:sectionType reload:current != NULL];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             if (self.hitThis == TRUE || (array != [StoriesSingleton sharedSingleton].Opinion2 && array != [StoriesSingleton sharedSingleton].moreOpinion))
                 [count setObject:[[NSNumber alloc] initWithInt:(int)([[count objectForKey:@"amount"] integerValue]) + 1] forKey:@"amount"];
             self.hitThis = TRUE;
             if (current != NULL && (array != [StoriesSingleton sharedSingleton].moreOpinion || (array == [StoriesSingleton sharedSingleton].moreOpinion && self.hitThis == TRUE))) {
                 [current addObjectsFromArray:array];
                 [[StoriesSingleton sharedSingleton].contentTableController loaded:current type:sectionType reload:TRUE];
             }
             else if ([[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue]) {
                 if (array == [StoriesSingleton sharedSingleton].Top1 || array == [StoriesSingleton sharedSingleton].Top2 || array == [StoriesSingleton sharedSingleton].Top3)
                     [self concatTop];
                 else if(array == [StoriesSingleton sharedSingleton].Opinion1 || (array == [StoriesSingleton sharedSingleton].Opinion2 && (self.hitThis == TRUE)))
                     [self concatOpinion];
                 else if (array == [StoriesSingleton sharedSingleton].Sports1 || array == [StoriesSingleton sharedSingleton].Sports2)
                     [self concatSports];
                 else if (array == [StoriesSingleton sharedSingleton].News1 || array == [StoriesSingleton sharedSingleton].News2)
                     [self concatNews];
                 else
                     [[StoriesSingleton sharedSingleton].contentTableController loaded:array type:sectionType reload:current != NULL];
             }
             NSLog(@"Error %@",error);
         }];
        [operation start];
    }
        if (array != [StoriesSingleton sharedSingleton].Opinion2 && array != [StoriesSingleton sharedSingleton].moreOpinion)
            return;
        NSURLRequest *headShotRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.hwchronicle.com/wp-content/uploads/userphoto/%@.jpg",[post valueForKeyPath:@"author.id"]]]];
        AFHTTPRequestOperation *headShotOperation = [[AFHTTPRequestOperation alloc]
                                             initWithRequest:headShotRequest];
        headShotOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [headShotOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id pic) {
            self.headShot = pic;
            if (self.hitThis == TRUE)
                [count setObject:[[NSNumber alloc] initWithInt:((int)[[count objectForKey:@"amount"] integerValue]) + 1] forKey:@"amount"];
            self.hitThis = TRUE;
            if (current != NULL && [[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue] && ([self.contentType isEqualToString:@"nopic"] || self.photo != NULL)) {
                [current addObjectsFromArray:array];
                [[StoriesSingleton sharedSingleton].contentTableController loaded:current type:sectionType reload:current != NULL];
            }
            else if ([[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue] && ([self.contentType isEqualToString:@"nopic"] || self.photo != NULL) && self.hitThis == TRUE)
                [self concatOpinion];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error){
            if (self.hitThis == TRUE)
                [count setObject:[[NSNumber alloc] initWithInt:((int)[[count objectForKey:@"amount"] integerValue])+1] forKey:@"amount"];
            self.hitThis = TRUE;
            if (current != NULL && [[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue] && ([self.contentType isEqualToString:@"nopic"] || self.photo != NULL)) {
                [current addObjectsFromArray:array];
                [[StoriesSingleton sharedSingleton].contentTableController loaded:current type:sectionType reload:current != NULL];
            }
            else if ([[count objectForKey:@"amount"] integerValue] == [[count objectForKey:@"capacity"] integerValue] && ([self.contentType isEqualToString:@"nopic"] || self.photo != NULL) && self.hitThis == TRUE)
                [self concatOpinion];
        }];
        [headShotOperation start];
    
}

-(NSDictionary*)dictionaryValue{
    NSArray *Ar1;
    NSArray *Ar2;
    if (self.photo != NULL && self.headShot != NULL) {
        Ar1=[[NSArray alloc]initWithObjects:@"name",@"content",@"url",@"title",@"excerpt",@"idnum",@"type",@"contentType",@"date",@"picWidth",@"picHeight",@"pic",@"head",nil];
        Ar2=[[NSArray alloc]initWithObjects:self.name,self.content,self.url,self.title,self.excerpt,self.idnum,self.type,self.contentType,self.date,[NSNumber numberWithInt:self.picWidth],[NSNumber numberWithInt:self.picHeight],UIImageJPEGRepresentation(self.photo, 1.0),UIImageJPEGRepresentation(self.headShot, 1.0),nil];
    }else if(self.photo != NULL){
        Ar1=[[NSArray alloc]initWithObjects:@"name",@"content",@"url",@"title",@"excerpt",@"idnum",@"type",@"contentType",@"date",@"picWidth",@"picHeight",@"pic",nil];
        Ar2=[[NSArray alloc]initWithObjects:self.name,self.content,self.url,self.title,self.excerpt,self.idnum,self.type,self.contentType,self.date,[NSNumber numberWithInt:self.picWidth],[NSNumber numberWithInt:self.picHeight],UIImageJPEGRepresentation(self.photo, 1.0),nil];
    }else if (self.headShot != NULL){
        Ar1=[[NSArray alloc]initWithObjects:@"name",@"content",@"url",@"title",@"excerpt",@"idnum",@"type",@"contentType",@"date",@"head",nil];
        Ar2=[[NSArray alloc]initWithObjects:self.name,self.content,self.url,self.title,self.excerpt,self.idnum,self.type,self.contentType,self.date,UIImageJPEGRepresentation(self.headShot, 1.0),nil];
    }
    else{
        Ar1=[[NSArray alloc]initWithObjects:@"name",@"content",@"url",@"title",@"excerpt",@"idnum",@"type",@"contentType",@"date",nil];
        Ar2=[[NSArray alloc]initWithObjects:self.name,self.content,self.url,self.title,self.excerpt,self.idnum,self.type,self.contentType,self.date,nil];
    }
    return [[NSDictionary alloc] initWithObjects:Ar2 forKeys:Ar1];
}

-(id)initWithDictionary:(NSDictionary*)dic{
    self.name = [dic objectForKey:@"name"];
    self.content = [dic objectForKey:@"content"];
    self.url = [dic objectForKey:@"url"];
    self.title = [dic objectForKey:@"title"];
    self.excerpt = [dic objectForKey:@"excerpt"];
    self.idnum = [dic objectForKey:@"idnum"];
    self.type = [dic objectForKey:@"type"];
    self.contentType = [dic objectForKey:@"contentType"];
    self.date = [dic objectForKey:@"date"];
    self.picWidth = [[dic objectForKey:@"picWidth"] intValue];
    self.picHeight = [[dic objectForKey:@"picHeight"] intValue];
    if ([dic objectForKey:@"pic"] != nil)
        self.photo = [UIImage imageWithData:(NSData *)[dic objectForKey:@"pic"]];
    if ([dic objectForKey:@"head"] != nil)
        self.headShot = [UIImage imageWithData:(NSData *)[dic objectForKey:@"head"]];
    return self;
}

-(void)concatOpinion{
    [[StoriesSingleton sharedSingleton].opinion removeAllObjects];
    [[StoriesSingleton sharedSingleton].opinion addObjectsFromArray:[StoriesSingleton sharedSingleton].Opinion1];
    [[StoriesSingleton sharedSingleton].opinion addObjectsFromArray:[StoriesSingleton sharedSingleton].Opinion2];
    [[StoriesSingleton sharedSingleton].contentTableController loaded:[StoriesSingleton sharedSingleton].opinion type:@"Opinion" reload:FALSE];
}

-(void)concatNews{
    [[StoriesSingleton sharedSingleton].NewsStories addObjectsFromArray:[StoriesSingleton sharedSingleton].News1];
    [[StoriesSingleton sharedSingleton].NewsStories addObjectsFromArray:[StoriesSingleton sharedSingleton].News2];
    [[StoriesSingleton sharedSingleton].contentTableController loaded:[StoriesSingleton sharedSingleton].NewsStories type:@"News" reload:FALSE];
}

-(void)concatSports{
    [[StoriesSingleton sharedSingleton].SportsStories addObjectsFromArray:[StoriesSingleton sharedSingleton].Sports1];
    [[StoriesSingleton sharedSingleton].SportsStories addObjectsFromArray:[StoriesSingleton sharedSingleton].Sports2];
    [[StoriesSingleton sharedSingleton].contentTableController loaded:[StoriesSingleton sharedSingleton].SportsStories type:@"Sports" reload:FALSE];
}

-(void)concatTop{
    [[StoriesSingleton sharedSingleton].TopStories addObjectsFromArray:[StoriesSingleton sharedSingleton].Top1];
    [[StoriesSingleton sharedSingleton].TopStories addObjectsFromArray:[StoriesSingleton sharedSingleton].Top2];
    [[StoriesSingleton sharedSingleton].TopStories addObjectsFromArray:[StoriesSingleton sharedSingleton].Top3];
    [[StoriesSingleton sharedSingleton].contentTableController loaded:[StoriesSingleton sharedSingleton].TopStories type:@"Top" reload:FALSE];
}

@end
