//
//  SideMenuViewController.h
//  theChronicle
//
//  Created by David Gisser on 1/9/14.
//  Copyright (c) 2014 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
