//
//  ContentViewCell.m
//  theChronicle
//
//  Created by David Gisser on 12/26/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "ContentViewCell.h"
#import "StoriesSingleton.h"
#import "NSString+HTML.h"
#import "SettingsSingleton.h"

@implementation ContentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.isGallery) {
            self.gallery = [GalleryModel makeView:self.story];
            [self.contentView addSubview:self.gallery.carousel];
            self.height=400;
            return self;
        }
        UIWebView *theContent = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 290, 200)];
        if (self.isVideo)
            theContent = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 290, 1)];
        if(self.height != 0)
            theContent = [[UIWebView alloc]initWithFrame:CGRectMake(8, 0, 290, self.height)];
        theContent.delegate = self;
        [theContent sizeToFit];
        NSMutableString *story = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<style>body{font-size:16px;font-family:\"%@\";line-height:20px;color:#333;}</style>%@",[SettingsSingleton sharedSingleton].contentFont,self.story]];
        if (self.isVideo) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"videoURL=\\\"([^\"]*)" options:0 error:nil];
            NSArray *matches = [regex matchesInString:story options:0 range:NSMakeRange(0, [story length])];
            if ([matches count]) {
                NSString *videoURL;
                for (NSTextCheckingResult *match in matches) {
                    //NSRange matchRange = [match range];
                    NSRange matchRange = [match rangeAtIndex:1];
                    videoURL = [story substringWithRange:matchRange];
                }
                regex = [NSRegularExpression regularExpressionWithPattern:@"playlistIDnum=\\\"([^\"]*)" options:0 error:nil];
                matches = [regex matchesInString:story options:0 range:NSMakeRange(0, [story length])];
                NSString *playlist;
                for (NSTextCheckingResult *match in matches) {
                    //NSRange matchRange = [match range];
                    NSRange matchRange = [match rangeAtIndex:1];
                    playlist = [story substringWithRange:matchRange];
                }
                regex = [NSRegularExpression regularExpressionWithPattern:@"watch\\?v=" options:0 error:nil];
                NSString *modifiedString = [regex stringByReplacingMatchesInString:videoURL options:0 range:NSMakeRange(0, [videoURL length]) withTemplate:@"embed/"];
                
                NSString* string = [NSString stringWithFormat:@"<p><iframe width=\"290\" src=\"%@?list=%@\" frameborder=\"0\" allowfullscreen></iframe></p>\n", modifiedString, playlist];
                [story setString:string];
                //<p><iframe width=\"300\" height=\"360\" src=\"http:\/\/www.youtube.com\/embed\/746SQ5O2a1g?list=PL0wLbbXn59xRUpm-fQpPxpnLYgqmJcrqO\" frameborder=\"0\" allowfullscreen><\/iframe><\/p>\n
            }
            regex = [NSRegularExpression regularExpressionWithPattern:@"width=\"[^\"]*\"" options:0 error:nil];
            [regex replaceMatchesInString:story options:0 range:NSMakeRange(0, [story length]) withTemplate:@"width=\"290\""];
            regex = [NSRegularExpression regularExpressionWithPattern:@"height=\"[^\"]*\"" options:0 error:nil];
            [regex replaceMatchesInString:story options:0 range:NSMakeRange(0, [story length]) withTemplate:@""];
        }else{
        NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"width=\"([^\"]*)\"" options:0 error:nil];
        NSArray *matches1 = [regex1 matchesInString:story options:0 range:NSMakeRange(0, [story length])];
        for (int x = 1; x <= [matches1 count]; x++){
            NSString *width;
            for (NSTextCheckingResult *match in matches1) {
                //NSRange matchRange = [match range];
                NSRange matchRange = [match rangeAtIndex:x];
                width = [story substringWithRange:matchRange];
            }
            [regex1 replaceMatchesInString:story options:0 range:NSMakeRange(0, [story length]) withTemplate:@"width=\"290\""];
            NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"height=\"([^\"]*)\"" options:0 error:nil];
             NSArray *matches2 = [regex2 matchesInString:story options:0 range:NSMakeRange(0, [story length])];
            NSString *height;
            for (NSTextCheckingResult *match in matches2) {
                //NSRange matchRange = [match range];
                NSRange matchRange = [match rangeAtIndex:x];
                height = [story substringWithRange:matchRange];
            }
            int heightnum = ((300*[height intValue])/[width intValue]);
            [regex2 replaceMatchesInString:story options:0 range:NSMakeRange(0, [story length]) withTemplate:[NSString stringWithFormat:@"%d",heightnum]];
        }}
        [theContent loadHTMLString:story baseURL:nil];
        theContent.scrollView.scrollEnabled = false;
        theContent.scrollView.delegate = self;
        [self.contentView addSubview:theContent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    if(self.height != 0 && self.height >= aWebView.scrollView.contentSize.height)
        return;
    self.height = aWebView.scrollView.contentSize.height;
    [[StoriesSingleton sharedSingleton].storyViewController reload];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > sender.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    else if (self.lastContentOffset < sender.contentOffset.y)
        scrollDirection = ScrollDirectionDown;
    
    self.lastContentOffset = sender.contentOffset.y;
    
    // do whatever you need to with scrollDirection here.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[StoriesSingleton sharedSingleton].storyViewController.webView loadRequest:request];
        [[StoriesSingleton sharedSingleton].storyViewController.webButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        return NO;
    }
    return YES;
}

@end