//
//  AppDelegate.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	
	[self customizeColors];
	
    return YES;
}

#pragma mark - Customizations

- (void)customizeColors {
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
	[SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
	[SVProgressHUD setForegroundColor:GLOBAL_RED_COLOR];
	
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_YELLOW_COLOR} forState:UIControlStateNormal];
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor]} forState:UIControlStateHighlighted];
	[[UISegmentedControl appearance] setTintColor:GLOBAL_YELLOW_COLOR];
	
	[[UITextField appearance] setTextColor:GLOBAL_TINT_COLOR];
	[[UITextField appearance] setTintColor:GLOBAL_TINT_COLOR];
	
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_RED_COLOR, NSFontAttributeName: [UIFont fontWithName:@"Neutraface2Display-Bold" size:20.0]}];
	
	[[UINavigationBar appearance] setTranslucent:NO];
	
	[[UINavigationBar appearance] setTintColor:GLOBAL_RED_COLOR];
	[[UINavigationBar appearance] setBarTintColor:GLOBAL_BACK_COLOR];
	
	[[UITabBar appearance] setTintColor:GLOBAL_YELLOW_COLOR];
	[[UITabBar appearance] setBarTintColor:GLOBAL_BACK_COLOR];
	
	[[UITableView appearance] setBackgroundColor:GLOBAL_BACK_COLOR];
	
	[[UITableViewCell appearance] setBackgroundColor:GLOBAL_GRAY_COLOR];
	
	[[UICollectionView appearance] setBackgroundColor:GLOBAL_BACK_COLOR];
	
	[[UICollectionViewCell appearance] setBackgroundColor:GLOBAL_GRAY_COLOR];
	
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_GRAY_COLOR } forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_YELLOW_COLOR} forState:UIControlStateSelected];
	
	[[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:GLOBAL_YELLOW_COLOR];
	
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
