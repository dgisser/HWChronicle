//
//  ContentTableController.m
//  theChronicle
//
//  Created by David Gisser on 1/7/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "ContentTableController.h"
#import "StoriesSingleton.h"
#import "NSString+HTML.h"
#import "SettingsSingleton.h"

@interface ContentTableController ()

@end

@implementation ContentTableController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [StoriesSingleton sharedSingleton].contentTableController = self;
    self.arraysGood = FALSE;
    self.toolbar.clipsToBounds = YES;
    self.type = [[NSString alloc] init];
    self.type = @"Top";
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
    view.delegate = self;
    [self.myTableView addSubview:view];
    self.refreshHeaderView = view;
    //[self.navigationController.navigationBar.layer setBorderWidth:2.0];// Just to make sure its working
    //[self.navigationController.navigationBar.layer setBorderColor:[[UIColor greenColor] CGColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    StoryViewController *next = segue.destinationViewController;
    next.otherCells = self.cells;
    next.delegate = self;
    next.index = self.currentIndex;
    next.added = 0;
    if ([self.type isEqualToString:@"Search"])
        next.added = 1;
    [self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)storytableViewControllerDidCancel:(StoryViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [self.some count];
    int added = 0;
    if ([self.type isEqualToString:@"Saved"] && [self.cells count] == 0)
        return 1;
    if ([self.type isEqualToString:@"Search"])
        added = 1;
    if (!self.arraysGood)
        return 10;
    return [self.cells count] + added;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int added = 0;
    if ([self.type isEqualToString:@"Search"])
        added = 1;
    if (([self.type isEqualToString:@"Saved"] && [self.cells count] == 0) || ([self.type isEqualToString:@"Search"] && indexPath.row == 0))
        return 44.0f;
    if (!self.arraysGood || [self.cells count] < indexPath.row)
        return 200.0f;
    return ((MasterMainTableViewCell *)([self.cells objectAtIndex:(indexPath.row - added)])).heightAdded;
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
    CGFloat screenSize = [[UIScreen mainScreen] bounds].size.height;
    if (screenSize == 480)
        self.box.center = CGPointMake(bounds.size.width/2, 125);
    else
        self.box.center = CGPointMake(bounds.size.width/2, 175);
    [self.box.layer setBorderWidth:3.0];// Just to make sure its working
    [self.box.layer setBorderColor:[[UIColor blackColor] CGColor]];
    self.box.layer.cornerRadius = 10.0f;
    self.box.backgroundColor = [UIColor whiteColor];
    [self.box addSubview:saved];
    [self.view addSubview:self.box];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int added = 0;
    if ([self.type isEqualToString:@"Search"]){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
            self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
            self.searchBar.delegate = self;
            self.searchBar.text = self.searchTerm;
            [cell.contentView addSubview:self.searchBar];
            return cell;
            
        }else{
            added = 1;
        }
    }
    if ([self.type isEqualToString:@"Saved"] && [self.cells count] == 0 && indexPath.row == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        label.text = @"No stories saved yet";
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont fontWithName:[SettingsSingleton sharedSingleton].bylineFont size:20]];
        [cell.contentView addSubview:label];
        return cell;
    }
    if (self.arraysGood && indexPath.row <= [self.cells count])
        return [self.cells objectAtIndex:(indexPath.row - added)];
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.searchTerm = [self.searchBar.text copy];
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    self.searchURL = [NSString stringWithFormat:@"http://www.hwchronicle.com/?s=%@&json=1",[self.searchTerm stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters]];
    [[StoriesSingleton sharedSingleton] getJSON:self.type:TRUE :FALSE];
    [self showMessage:@"Loading..."];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    int added = 0;
    if (([self.type isEqualToString:@"Saved"] && [self.cells count] == 0) || ([self.type isEqualToString:@"Search"] && indexPath.row == 0))
        return;
    if ([self.type isEqualToString:@"Search"]) {
        added = 1;
    }
    if (self.arraysGood) {
        self.currentIndex = (int)indexPath.row;
        [self performSegueWithIdentifier:@"two" sender:self];
    }
}

- (void)loaded:(NSMutableArray*)current type:(NSString*)type reload:(BOOL)reload{
    if (![type isEqualToString:self.type] || [type isEqualToString:@"Reading List"])
        return;
    self.arraysGood = TRUE;
    [self.box removeFromSuperview];
    self.cells = [[NSMutableArray alloc] init];
    for (StoryUnzipper* x in current) {
        MasterMainTableViewCell *cell = [MasterMainTableViewCell alloc];
        cell.story = x;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [self.cells addObject:cell];
    }
    if ([type isEqualToString:@"Search"] && [current count] == 1) {
        MasterMainTableViewCell *cell = [MasterMainTableViewCell alloc];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        cell.heightAdded = 30;
        label.text = @"No results";
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont fontWithName:[SettingsSingleton sharedSingleton].bylineFont size:20]];
        [cell.contentView addSubview:label];
        [self.cells addObject:cell];
    }
    if (!reload)
        [self.myTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self.myTableView reloadData];
    self.myTableView.hidden = FALSE;
    [self.button setTitle:self.type forState:UIControlStateDisabled];
    if ([type isEqualToString:@"Top"])
        [self.button setTitle:@"Front Page" forState:UIControlStateDisabled];
    if ([type isEqualToString:@"Gallery"])
        [self.button setTitle:@"Photo Gallery" forState:UIControlStateDisabled];
    if (self.loading)
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.loadingpopup setFrame:CGRectMake(0.0f, self.myTableView.frame.origin.y + self.myTableView.frame.size.height, self.myTableView.frame.size.width, self.loadingpopup.frame.size.height)];
        } completion:^(BOOL finished) {
            
        }];
    self.loading = FALSE;
}

- (IBAction)sideMenu:(id)sender {
    [[StoriesSingleton sharedSingleton].pkRevealController showViewController:[StoriesSingleton sharedSingleton].pkRevealController.rightViewController];
}

/*- (IBAction)switchtoSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://hwchronicle.com/"]];
}*/

- (void)reloadTableViewDataSource{
    [[StoriesSingleton sharedSingleton] getJSON:self.type:TRUE :FALSE];
    self.reloading = TRUE;
}

- (void)doneLoadingTableViewData{
    self.reloading = FALSE;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    scrollDirection scrollDirection;
    if (self.lastContentOffset < scrollView.contentOffset.y && ![self.type isEqualToString:@"Saved"]){
        scrollDirection = scrollDirectionDown;
        if (self.myTableView.contentOffset.y >= (self.myTableView.contentSize.height - self.myTableView.bounds.size.height) && (self.myTableView.contentOffset.y >= 0) && !self.loading && (![self.type isEqualToString:@"Saved"] || ([self.type isEqualToString:@"Saved"] && self.searchURL != NULL))) {
            self.loadingpopup = [[UIView alloc] initWithFrame:CGRectMake(0, self.myTableView.frame.origin.y + self.myTableView.frame.size.height, self.myTableView.frame.size.width, 30.0f)];
            self.loadingpopup.backgroundColor = [UIColor whiteColor];
            UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            loading.textAlignment = NSTextAlignmentCenter;
            loading.text = @"Loading stories below...";
            [loading setFont:[UIFont fontWithName:[SettingsSingleton sharedSingleton].bylineFont size:17]];
            [self.loadingpopup.layer setBorderWidth:1.0];// Just to make sure its working
            [self.loadingpopup.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [self.loadingpopup addSubview:loading];
            [self.view addSubview:self.loadingpopup];
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                [self.loadingpopup setFrame:CGRectMake(0.0f, self.myTableView.frame.origin.y + self.myTableView.frame.size.height - 30.0f, self.myTableView.frame.size.width, self.loadingpopup.frame.size.height)];
            } completion:^(BOOL finished) {
                
            }];
            [[StoriesSingleton sharedSingleton] getJSON:self.type:FALSE :TRUE];
            self.loading = TRUE;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
