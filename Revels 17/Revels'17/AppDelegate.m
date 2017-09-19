//
//  AppDelegate.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

@import Firebase;

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "AppDelegate.h"
#import "CategoriesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	
	[self customizeColors];
	
	// For the "GoogleService-Info.plist", contact LUGM
	[FIRApp configure];
	
	UIMutableApplicationShortcutItem *catItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"favorites" localizedTitle:@"Favorites"];
	[catItem setIcon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"44favouritesIcon"]];
	UIMutableApplicationShortcutItem *eventsItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.da.revels.events" localizedTitle:@"Events"];
	[eventsItem setIcon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"44eventIcon"]];
	UIMutableApplicationShortcutItem *instaItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.da.revels.instafeed" localizedTitle:@"Instafeed"];
	[instaItem setIcon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"44instagramLogo"]];
	UIMutableApplicationShortcutItem *resultsItem = [[UIMutableApplicationShortcutItem alloc] initWithType:@"com.da.revels.results" localizedTitle:@"Results"];
	[resultsItem setIcon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"44resultsIcon"]];
	[application setShortcutItems:@[catItem, eventsItem, instaItem, resultsItem]];
	
	
	
    return YES;
}

#pragma mark - Customizations

- (void)customizeColors {
	
	[[IQKeyboardManager sharedManager] setEnable:YES];
	[[IQKeyboardManager sharedManager] setKeyboardAppearance:UIKeyboardAppearanceDark];
	
	[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
	[SVProgressHUD setBackgroundColor:GLOBAL_GRAY_COLOR];
	[SVProgressHUD setForegroundColor:GLOBAL_YELLOW_COLOR];
	
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_YELLOW_COLOR, NSFontAttributeName: GLOBAL_FONT_BOLD(14)} forState:UIControlStateNormal];
	[[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightTextColor], NSFontAttributeName: GLOBAL_FONT_BOLD(14)} forState:UIControlStateHighlighted];
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
	
	[[UICollectionViewCell appearance] setBackgroundColor:GLOBAL_GRAY_COLOR];
	
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_GRAY_COLOR } forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: GLOBAL_YELLOW_COLOR} forState:UIControlStateSelected];
	
	[[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:GLOBAL_YELLOW_COLOR];
	
}

+ (BOOL)fiveMinutesSinceLastUpdateDate {
	NSDate *current = [NSDate date];
	NSDate *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SAVED"];
	if (saved == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:current forKey:@"LAST_SAVED"];
		return YES;
	}
	NSLog(@"Last updated %f seconds ago.", [current timeIntervalSinceDate:saved]);
	if ([current timeIntervalSinceDate:saved] > 300) {
		[[NSUserDefaults standardUserDefaults] setObject:current forKey:@"LAST_SAVED"];
		return YES;
	}
	return NO;
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


#pragma mark - Handling force touch shortcuts

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	
	UITabBarController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
	
	if ([shortcutItem.type containsString:@"favorites"]) {
		tabBarVC.selectedIndex = 0;
		UINavigationController *navc = [tabBarVC.viewControllers firstObject];
		CategoriesViewController *catvc = [navc.viewControllers firstObject];
		catvc.pushFavs = YES;
	}
	else if ([shortcutItem.type containsString:@"events"])
		tabBarVC.selectedIndex = 1;
	else if ([shortcutItem.type containsString:@"instafeed"])
		tabBarVC.selectedIndex = 2;
	else if ([shortcutItem.type containsString:@"results"])
		tabBarVC.selectedIndex = 3;
	
	self.window.rootViewController = tabBarVC;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
	// The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
	@synchronized (self) {
		if (_persistentContainer == nil) {
			_persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RevelsCoreData"];
			[_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
				if (error != nil) {
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					
					/*
					 Typical reasons for an error here include:
					 * The parent directory does not exist, cannot be created, or disallows writing.
					 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
					 * The device is out of space.
					 * The store could not be migrated to the current model version.
					 Check the error message to determine what the actual problem was.
					 */
					NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//					abort();
				}
			}];
		}
	}
	
	return _persistentContainer;
}

+ (NSPersistentContainer *)sharedPersistentContainer {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.persistentContainer;
}

+ (NSManagedObjectContext *)sharedManagedObjectContext {
	NSPersistentContainer *container = [AppDelegate sharedPersistentContainer];
	return [container viewContext];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
	NSManagedObjectContext *context = self.persistentContainer.viewContext;
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//		abort();
	}
}

@end
