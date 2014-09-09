//
//  StoryViewController.m
//  theChronicle
//
//  Created by David Gisser on 1/8/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "StoryViewController.h"
#import "StoriesSingleton.h"
#import "BylineTableViewCell.h"
#import "PictureTableViewCell.h"
#import "ContentViewCell.h"
#import "ExcerptViewCell.h"
#import "NSString+HTML.h"
#import "PersistentDictionary.h"
#import "JFTimeFormatter.h"
#import "SettingsSingleton.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int count = (int)indexPath.row;
    if (self.haspic)
        count --;
    if (count == -1)
        return ((PictureTableViewCell *)[self.cells objectAtIndex:indexPath.row]).picHeight + 20;
    if (count == 0)
        return ((BylineTableViewCell *)[self.cells objectAtIndex:indexPath.row]).height + 5;
    if (count == 1)
        return ((ContentViewCell *)[self.cells objectAtIndex:indexPath.row]).height + 5;
    return ((ExcerptViewCell *)[self.cells objectAtIndex:indexPath.row]).height + 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [StoriesSingleton sharedSingleton].storyViewController = self;
    [self changeStory];
    self.toolbar.clipsToBounds = YES;
    [self.toolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [self.toolbar setShadowImage:[UIImage new]
              forToolbarPosition:UIToolbarPositionAny];
    self.toolbar.tintColor = [UIColor whiteColor];
    [StoriesSingleton sharedSingleton].storyViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor]; //make back button white
    //if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)changeStory{
    [self.upArrow setEnabled:YES];
    [self.downArrow setEnabled:YES];
    bool isGallery = [((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Photo"];
    if (self.index == 0 + self.added)
        [self.upArrow setEnabled:NO];
    else if(self.index == [self.otherCells count] -1 + self.added)
        [self.downArrow setEnabled:NO];
    self.cells = [[NSMutableArray alloc] init];
    self.haspic = FALSE;
    //NSLog(@"%@",((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type);
    StoryUnzipper *thisStory = (StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story;
    if ([thisStory.contentType isEqualToString:@"pic"] && ![((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Video"] && !isGallery) {
        self.haspic = TRUE;
        PictureTableViewCell *cell1 = [PictureTableViewCell alloc];
        cell1.pic = thisStory.photo;
        cell1.picHeight = thisStory.picHeight;
        cell1.picWidth = thisStory.picWidth;
        cell1 = [cell1 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        [self.cells addObject:cell1];
    }
    BylineTableViewCell *cell3 = [BylineTableViewCell alloc];
    cell3.title = thisStory.title;
    cell3.byline = thisStory.name;
    cell3.head = thisStory.headShot;
    NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
    mmddccyy.timeStyle = NSDateFormatterNoStyle;
    mmddccyy.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *d = [mmddccyy dateFromString:thisStory.date];
    cell3.date = [JFTimeFormatter relativeDateStringFromTime:[d timeIntervalSince1970]];
    cell3 = [cell3 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
    [self.cells addObject:cell3];
    ContentViewCell *cell4 = [ContentViewCell alloc];
    cell4.story = thisStory.content;
    cell4.isVideo = FALSE;
    if ([((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Video"])
        cell4.isVideo = TRUE;
    if (isGallery)
        cell4.isGallery = TRUE;
    cell4 = [cell4 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
    [self.cells addObject:cell4];
    if ([((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Video"]){
        ExcerptViewCell *cell5 = [ExcerptViewCell alloc];
        cell5.excerpt = thisStory.excerpt;
        cell5 = [cell5 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell4"];
        [self.cells addObject:cell5];
    }
    self.storyTable.hidden = FALSE;
    [self.box removeFromSuperview];
    [self.bookmark setImage:[UIImage imageNamed:@"openbookmark.png"] forState:UIControlStateNormal];
    PersistentDictionary *ids = [PersistentDictionary dictionaryWithName:@"ids"];
    if([ids.dictionary objectForKey:@"ids"] != nil){
        for (NSString *anID in ((NSMutableArray*)[ids.dictionary objectForKey:@"ids"])) {
            if ([anID isEqualToString:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum])
                [self.bookmark setImage:[UIImage imageNamed:@"closedBookmark.png"] forState:UIControlStateNormal];
        }
    }
    [self.storyTable setContentOffset:self.storyTable.contentOffset animated:NO];
    [self.storyTable setContentOffset:self.storyTable.contentOffset animated:YES];
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,460.0)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    NSURL *url = [NSURL URLWithString:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
    self.storyTable.hidden = FALSE;
    self.webView.hidden = TRUE;
}

- (IBAction)seeWeb:(UIButton *)sender {
    if (self.storyTable.hidden == FALSE) {
        [UIView transitionWithView:sender.imageView duration:0.3
           options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
               sender.imageView.image = [UIImage imageNamed:@"square.png"];
           } completion:nil];
        [sender setImage:[UIImage imageNamed:@"square.png"] forState:UIControlStateNormal];
        self.storyTable.hidden = TRUE;
        self.webView.hidden = FALSE;
    }
    else{
        [UIView transitionWithView:sender.imageView duration:0.3
           options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
               sender.imageView.image = [UIImage imageNamed:@"square.png"];
           } completion:nil];
        [sender setImage:[UIImage imageNamed:@"globe_filled.png"] forState:UIControlStateNormal];
        self.storyTable.hidden = FALSE;
        self.webView.hidden = TRUE;
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (CGRectIsEmpty(self.barRect)) {
        self.barRect = self.toolBar.frame;
        self.tableRect = self.storyTable.frame;
        self.tableBounds = self.storyTable.bounds;
    }
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > sender.contentOffset.y){
        scrollDirection = ScrollDirectionUp;
        if ((self.storyTable.contentOffset.y <= (self.storyTable.contentSize.height - self.storyTable.bounds.size.height)) && (self.storyTable.contentOffset.y >= 0)){
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.toolBar setFrame:self.barRect];
                [self.storyTable setFrame:self.tableRect];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else if (self.lastContentOffset < sender.contentOffset.y){
        scrollDirection = ScrollDirectionDown;
        if ((self.storyTable.contentOffset.y <= (self.storyTable.contentSize.height - self.storyTable.bounds.size.height) && (self.storyTable.contentOffset.y >= 0)) && !self.scrolling){
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.toolBar setFrame:CGRectMake(0.0f, self.tableRect.size.height + self.barRect.size.height, self.barRect.size.width, self.barRect.size.height)];
                [self.storyTable setFrame:CGRectMake(0.0f, 0.0f, self.tableRect.size.width, self.tableRect.size.height + self.barRect.size.height)];
            } completion:^(BOOL finished) {
                
            }];
        }else if (self.storyTable.contentOffset.y > (self.storyTable.contentSize.height - self.storyTable.bounds.size.height) && (self.storyTable.contentSize.height > self.barRect.size.height + self.tableRect.size.height)) {
            //[self.storyTable setContentOffset:CGPointMake(self.storyTable.contentOffset.x, self.storyTable.contentSize.height - self.storyTable.frame.size.height)];
            self.storyTable.bounces = FALSE;
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.toolBar setFrame:self.barRect];
                [self.storyTable setFrame:self.tableRect];
                self.scrolling = TRUE;
            } completion:^(BOOL finished) {
                self.scrolling = FALSE;
                self.storyTable.bounces = TRUE;
            }];
        }
        //= CGAffineTransformMakeTranslation(0, 80);
    }

    self.lastContentOffset = sender.contentOffset.y;
}

- (IBAction)save:(UIBarButtonItem *)sender {
    [self.box removeFromSuperview];
    [self.timer invalidate];
    PersistentDictionary *pdic = [PersistentDictionary dictionaryWithName:[NSString stringWithFormat:@"%@",((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum]];
    
    PersistentDictionary *ids = [PersistentDictionary dictionaryWithName:@"ids"];
    if([ids.dictionary objectForKey:@"ids"] != nil){
        for (NSString *anID in ((NSMutableArray*)[ids.dictionary objectForKey:@"ids"])) {
            if ([anID isEqualToString:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum]) {
                [pdic deleteDictionary];
                [((NSMutableArray*)[ids.dictionary objectForKey:@"ids"]) removeObject:anID];
                [PersistentDictionary saveAllDictionaries];
                [self showMessage:@"Deleted!"];
                [self.bookmark setImage:[UIImage imageNamed:@"openbookmark.png"] forState:UIControlStateNormal];
                if ([[StoriesSingleton sharedSingleton].contentTableController.type isEqualToString:@"Saved"]) {
                    [[StoriesSingleton sharedSingleton].storyViewController.navigationController popToRootViewControllerAnimated:YES];
                    [[StoriesSingleton sharedSingleton] getJSON:[StoriesSingleton sharedSingleton].contentTableController.type:TRUE :FALSE];
                }
                return;
            }
        }
        [((NSMutableArray*)[ids.dictionary objectForKey:@"ids"]) insertObject:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum atIndex:0];
    }else{
        NSMutableArray *idsArray = [[NSMutableArray alloc] init];
        [idsArray addObject:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum];
        [ids.dictionary setObject:idsArray forKey:@"ids"];
    }
    [pdic.dictionary setObject:[((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story) dictionaryValue] forKey:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).idnum];
    [PersistentDictionary saveAllDictionaries];
    [self showMessage:@"Saved!"];
    [self.bookmark setImage:[UIImage imageNamed:@"closedBookmark.png"] forState:UIControlStateNormal];
}

- (void)showMessage:(NSString*)message{
    CGRect size = CGRectMake(0, 0, 150, 150);
    self.box = [[UIView alloc] initWithFrame:size];
    CGRect labelSize = CGRectMake(0, 50, 150, 50);
    UILabel *saved = [[UILabel alloc] initWithFrame:labelSize];
    saved.text = message;
    saved.textAlignment = NSTextAlignmentCenter;
    [saved setFont:[UIFont fontWithName:[SettingsSingleton sharedSingleton].titleFont size:23]];
    CGRect bounds = self.view.bounds;
    self.box.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    [self.box.layer setBorderWidth:3.0];// Just to make sure its working
    [self.box.layer setBorderColor:[[UIColor blackColor] CGColor]];
    self.box.layer.cornerRadius = 10.0f;
    self.box.backgroundColor = [UIColor whiteColor];
    [self.box addSubview:saved];
    [self.view addSubview:self.box];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeSave) userInfo:nil repeats:NO];
}

-(void)removeSave{
    [self.box removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tableIndex = (int)indexPath.row;
    if (tableIndex < 3)
        return [self.cells objectAtIndex:tableIndex];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.haspic || [((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Video"])
        return 3;
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)reload{
    ContentViewCell *cell = [ContentViewCell alloc];
    if ([((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Video"]){
        cell.isVideo = TRUE;
        cell.height = ((ContentViewCell *)[self.cells objectAtIndex:([self.cells count]-2)]).height;
        [self.cells removeObjectAtIndex:[self.cells count]-2];
        cell.story = ((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).content;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
        [self.cells insertObject:cell atIndex:[self.cells count]-1];
    } else if ([((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).type isEqualToString:@"Photo"])
        cell.isGallery = TRUE;
    else{
        cell.height = ((ContentViewCell *)[self.cells objectAtIndex:([self.cells count]-1)]).height;
        cell.isVideo = FALSE;
        [self.cells removeLastObject];
        cell.story = ((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).content;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell3"];
        [self.cells addObject:cell];
    }
    [self.storyTable reloadData];
}

- (IBAction)onShare:(id)sender {
    NSURL *url = [NSURL URLWithString:((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).url];
    NSArray *activityItems = nil;
    
    if (((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).photo != nil) {
        activityItems = @[[((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).title stringByDecodingHTMLEntities], ((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).photo, url];
    } else {
        activityItems = @[[((StoryUnzipper*)((MasterMainTableViewCell*)[self.otherCells objectAtIndex:(self.index - self.added)]).story).title stringByDecodingHTMLEntities],url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)selectButton:(UIButton *)item{
    if(item.tag == 0){
        self.index --;
        self.storyTable.hidden = FALSE;
        self.webView.hidden = TRUE;
        [self changeStory];
        [self.storyTable reloadData];
    }
    if (item.tag == 1) {
        self.index ++;
        self.storyTable.hidden = FALSE;
        self.webView.hidden = TRUE;
        [self changeStory];
        [self.storyTable reloadData];
    }
}

/*- (BOOL)prefersStatusBarHidden
{
    return YES;
}*/

@end
