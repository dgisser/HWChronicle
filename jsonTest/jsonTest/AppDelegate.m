//
//  AppDelegate.m
//  jsonTest
//
//  Created by David Gisser on 9/1/13.
//  Copyright (c) 2013 Harvard-Westlake Chronicle. All rights reserved.
//

#import "AppDelegate.h"
#import "StoriesSingleton.h"
#import "ContentTableController.h"
#import "SideMenuViewController.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeNewsstandContentAvailability);
    [[StoriesSingleton sharedSingleton] getJSON:@"Top" :FALSE :FALSE];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ContentTableController *initViewController = (ContentTableController *) self.window.rootViewController;
    [StoriesSingleton sharedSingleton].navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigation"];
    SideMenuViewController *rearVC = [storyboard instantiateViewControllerWithIdentifier:@"table"];
    PKRevealController *revealController = [PKRevealController revealControllerWithFrontViewController:initViewController rightViewController:rearVC];
    [StoriesSingleton sharedSingleton].pkRevealController = revealController;
    self.window.rootViewController = revealController;
    //[revealController showViewController:revealController.leftViewController];
    //remove saved stories???!!!!
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"background.png"]];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"HSGJK8469Q6YYMD9KBNV"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)startPresentationMode
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && [className isEqualToString:@"MPInlineVideoFullscreenViewController"]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
