//
//  ContentTableController.h
//  theChronicle
//
//  Created by David Gisser on 1/7/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryViewController.h"
#import "PKRevealController.h"
#import "MasterMainTableViewCell.h"
#import "EGORefreshTableHeaderView.h"

@class ContentTableController;

@interface ContentTableController : UIViewController <StoryViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, PKRevealing, UINavigationBarDelegate, EGORefreshTableHeaderDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) UIView *loadingpopup;
@property (strong, nonatomic) MasterMainTableViewCell *storyType;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSString *searchURL;
@property (strong, nonatomic) NSMutableArray *cells;
@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign) BOOL arraysGood;
@property (assign) BOOL reloading;
@property (assign) BOOL loading;
@property (assign, nonatomic) int currentIndex;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) UIView *box;
@property (nonatomic, assign) NSInteger lastContentOffset;
- (void)loaded:(NSMutableArray*)current type:(NSString*)type reload:(BOOL)reload;
- (IBAction)sideMenu:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

typedef enum scrollDirection {
    scrollDirectionNone,
    scrollDirectionRight,
    scrollDirectionLeft,
    scrollDirectionUp,
    scrollDirectionDown,
} scrollDirection;

@end
