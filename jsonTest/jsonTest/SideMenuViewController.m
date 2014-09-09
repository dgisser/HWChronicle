//
//  SideMenuViewController.m
//  theChronicle
//
//  Created by David Gisser on 1/9/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuCell.h"
#import "StoriesSingleton.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [self.some count];
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [StoriesSingleton sharedSingleton].contentTableController.type = ((SideMenuCell*)([tableView cellForRowAtIndexPath:indexPath])).type;
    [[StoriesSingleton sharedSingleton].contentTableController.button setTitle:@"Loading..." forState:UIControlStateDisabled];
    [[StoriesSingleton sharedSingleton] getJSON:((SideMenuCell*)([tableView cellForRowAtIndexPath:indexPath])).type :FALSE :FALSE];
    [[StoriesSingleton sharedSingleton].pkRevealController resignPresentationModeEntirely:YES animated:YES completion:Nil];
    if ([StoriesSingleton sharedSingleton].storyViewController.isViewLoaded && [StoriesSingleton sharedSingleton].storyViewController.view.window)
        [[StoriesSingleton sharedSingleton].storyViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tableIndex = (int)indexPath.row;
    SideMenuCell *cell = [SideMenuCell alloc];
    if (tableIndex == 0)
        cell.type = @"Top";
    else if (tableIndex == 1)
        cell.type = @"News";
    else if (tableIndex == 2)
        cell.type = @"Sports";
    else if (tableIndex == 3)
        cell.type = @"Features";
    else if (tableIndex == 4)
        cell.type = @"Opinion";
    else if (tableIndex == 5)
        cell.type = @"Gallery";
    else if (tableIndex == 6)
        cell.type = @"Video";
    else if (tableIndex == 7)
        cell.type = @"Saved";
    else if (tableIndex == 8)
        cell.type = @"Search";
    cell = [cell init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenSize = [[UIScreen mainScreen] bounds].size.height;
    if (screenSize == 480)
        return 46;
    else
        return 55.8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 20;
}

@end
