//
//  AppDelegate.h
//  jsonTest
//
//  Created by David Gisser on 9/1/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "UAInbox.h"
#import "UAInboxUI.h"
#import "PKRevealController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PKRevealing>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) PKRevealController *revealController;

@end