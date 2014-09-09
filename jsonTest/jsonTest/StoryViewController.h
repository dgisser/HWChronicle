//
//  StoryViewController.h
//  theChronicle
//
//  Created by David Gisser on 1/8/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryViewController;

@protocol StoryViewControllerDelegate <NSObject>

- (void)storytableViewControllerDidCancel:(StoryViewController *)controller;

@end

@interface StoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *storyTable;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *bookmark;
@property (weak, nonatomic) IBOutlet UIButton *upArrow;
@property (weak, nonatomic) IBOutlet UIButton *downArrow;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (retain, nonatomic) UIWebView *webView;
@property (nonatomic, weak) id <StoryViewControllerDelegate> delegate;
@property (assign) int index;
@property (nonatomic, assign) CGRect barRect;
@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, assign) CGRect tableBounds;
@property (assign) int added;
@property (assign) BOOL scrolling;
@property (assign) BOOL arraysGood;
@property (assign) BOOL haspic;
@property (strong, nonatomic) NSMutableArray *cells;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *otherCells;
@property (retain, nonatomic) UIView *box;
@property (nonatomic, assign) NSInteger lastContentOffset;
- (void)reload;
- (IBAction)onShare:(id)sender;
- (void)changeStory;
- (IBAction)seeWeb:(UIButton*)sender;
- (IBAction)save:(id)sender;
- (void)removeSave;
- (void)showMessage:(NSString*)message;
- (IBAction)selectButton:(UIButton *)item;

@end