//
//  ResultsViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "AllResultsTableViewController.h"
#import "SportsResultsTableViewController.h"

#import "ResultsViewController.h"

#import "ResultsTableViewCell.h"

#import "ResultsJSONModel.h"
#import "SportsDetailsJSONModel.h"

#import "EventStore+CoreDataClass.h"

@interface ResultsViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic) NSArray <EventStore *> *events;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) NSArray *allResults;
@property (nonatomic) NSArray *sportsResults;

@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) UISearchController *searchController;

@property (nonatomic) AllResultsTableViewController *allResultsController;
@property (nonatomic) SportsResultsTableViewController *sportsResultsController;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.title = @"Results";
    self.context = [AppDelegate sharedManagedObjectContext];
	
	self.allResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"AllResultsVC"];
	self.sportsResultsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SportsResultsVC"];
    
    self.allResults = [NSArray new];
	self.sportsResults = [NSArray new];
	
	[self loadResultsFromApi:self];
	
    NSError *error;
	self.events = [self.context executeFetchRequest:[EventStore fetchRequest] error:&error];
	self.allResultsController.events = self.events;
	self.sportsResultsController.events = self.events;
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadResultsFromApi:)];
	self.navigationItem.leftBarButtonItem = refreshButton;
	
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self addChildViewController:self.pageViewController];
	
	[self.pageViewController setViewControllers:@[self.allResultsController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

	self.segmentedControl.selectedSegmentIndex = 0;
	
	[self setupSearchController];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.containerView addSubview:self.pageViewController.view];
	[self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.pageViewController.view.frame = self.containerView.bounds;
	self.pageViewController.view.clipsToBounds = YES;
	[self.pageViewController didMoveToParentViewController:self];
}

- (void)setupSearchController {
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.searchBar.barTintColor = GLOBAL_BACK_COLOR;
	self.searchController.searchBar.tintColor = GLOBAL_YELLOW_COLOR;
	UITextField *txfSearchField = [self.searchController.searchBar valueForKey:@"_searchField"];
	[txfSearchField setTextColor:GLOBAL_YELLOW_COLOR];
	[txfSearchField setFont:GLOBAL_FONT_BOLD(14)];
	self.searchController.searchBar.placeholder = @"Team ID, Event, or Category...";
	self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
	self.definesPresentationContext = NO;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.navigationItem.titleView = self.searchController.searchBar;
}

- (void)loadResultsFromApi:(id)sender {
	SVHUD_SHOW;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		@try {
			
			NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/results/"];
			NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
			NSError *error;
			SVHUD_HIDE;
			
			if (mydata!=nil) {
				id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
				id array = [jsonData valueForKey:@"data"];
		
				dispatch_async(dispatch_get_main_queue(), ^{
					self.allResults = [ResultsJSONModel getArrayFromJson:array];
					for (ResultsJSONModel *model in self.allResults) {
						EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eventID == %@", model.eventID]] firstObject];
						model.categoryName = event.catName;
					}
					[self.allResultsController filterResultsWithSearchText:@""];
				});
			}
			
		} @catch (NSException *exception) {
			
		}
	});
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		@try {
			NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/sports/"];
			NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
			NSError *error;
			if (mydata!=nil) {
				SVHUD_HIDE;
				id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
				id array = [jsonData valueForKey:@"data"];
				dispatch_async(dispatch_get_main_queue(), ^{
					self.sportsResults = [SportsDetailsJSONModel getArrayFromJson:array];
					[self.sportsResultsController filterResultsWithSearchText:@""];
				});
			}
			
		} @catch (NSException *exception) {
			
		}
	});
}

- (void)setAllResults:(NSArray *)allResults {
	_allResults = allResults;
	self.allResultsController.allResults = allResults;
}

- (void)setSportsResults:(NSArray *)sportsResults {
	_sportsResults = sportsResults;
	self.sportsResultsController.allResults = sportsResults;
}

- (IBAction)segmentedControlValueChanged:(id)sender {
	NSInteger index = [sender selectedSegmentIndex];
	if (index == 0) {
		[self.pageViewController setViewControllers:@[self.allResultsController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
	} else {
		[self.pageViewController setViewControllers:@[self.sportsResultsController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	}
}

#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	if (viewController == self.sportsResultsController)
		return self.allResultsController;
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	if (viewController == self.allResultsController)
		return self.sportsResultsController;
	return nil;
}

#pragma mark - Page view controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	if (finished) {
		[self.segmentedControl setSelectedSegmentIndex:[pageViewController.viewControllers.lastObject isKindOfClass:[SportsResultsTableViewController class]]];
	}
}

#pragma mark - Search controller

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	UISearchBar *searchBar = self.searchController.searchBar;
	NSString *searchText = searchBar.text;
	[self.allResultsController filterResultsWithSearchText:searchText];
	[self.sportsResultsController filterResultsWithSearchText:searchText];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
