//
//  EventsViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsByDayTableViewController.h"
#import "EventsDetailsJSONModel.h"

@interface EventsViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UISearchResultsUpdating, UISearchControllerDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *eventsSegmentedView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSMutableArray <EventsByDayTableViewController *> *viewControllers;

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *eventRequest;
@property (nonatomic) NSFetchRequest *scheduleRequest;

@property (nonatomic) UISearchController *searchController;

@end

@implementation EventsViewController {
	NSInteger lastIndex;
    NSMutableArray *eveArray;
	NSMutableArray *scheduleArray;
}

-(void)loadEventsFromApi
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            
            NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/events/"];
            NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
            NSError *error;
            
            if (mydata!=nil)
            {
				
				SVHUD_HIDE;
				
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
			
				eveArray = [CoreDataHelper getEventsFromJSONData:array storeIntoManagedObjectContext:self.context];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					NSError *err;
					[self.context save:&err];
					if (err != nil) {
						NSLog(@"Error in saving: %@", err.localizedDescription);
					}
					if (scheduleArray.count > 0 && eveArray.count > 0) {
						NSLog(@"Both schedule and events present; populating children");
						[self populateChildControllers];
					}
				});
	
				
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
}

- (void)loadScheduleFromApi
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		
		@try {
			
			NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/schedule/"];
			NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
			NSError *error;
			
			if (mydata!=nil)
			{
				
				SVHUD_HIDE;
				
				id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
				id array = [jsonData valueForKey:@"data"];
			
				scheduleArray = [CoreDataHelper getScheduleFromJSONData:array storeIntoManagedObjectContext:self.context];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					NSError *err;
					[self.context save:&err];
					if (err != nil) {
						NSLog(@"Error in saving: %@", err.localizedDescription);
					}
					if (scheduleArray.count > 0 && eveArray.count > 0) {
						NSLog(@"Both schedule and events present; populating children.");
						[self populateChildControllers];
					}
				});
				
				
			}
			
		}
		@catch (NSException *exception) {
			
		}
		@finally {
			
		}

		
	});
}

- (void)populateChildControllers {
	
	for (NSInteger i = 0; i < 4; i++) {
		EventsByDayTableViewController *ebdtvc = [self.viewControllers objectAtIndex:i];
		NSArray *filteredSchedules = [scheduleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", [NSString stringWithFormat:@"%li", i + 1]]];
		ebdtvc.schedules = filteredSchedules;
	}
	EventsByDayTableViewController *etvc = [self.viewControllers firstObject];
	[etvc.tableView reloadData];
	[self eventDayChanged:self.eventsSegmentedView];
	
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.context = [AppDelegate sharedManagedObjectContext];
	
	self.eventRequest = [EventStore fetchRequest];
	[self.eventRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]]];
	
	self.scheduleRequest = [ScheduleStore fetchRequest];
	[self.scheduleRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stime" ascending:YES]]];
	
	eveArray = [NSMutableArray new];
	scheduleArray = [NSMutableArray new];
	
	NSError *error;
	
	eveArray = [[self.context executeFetchRequest:self.eventRequest error:&error] mutableCopy];
	scheduleArray = [[self.context executeFetchRequest:self.scheduleRequest error:&error] mutableCopy];

	if (eveArray.count == 0 || scheduleArray.count == 0) {
		SVHUD_SHOW;
	}
	
    self.viewControllers = [NSMutableArray new];
	
	for (NSInteger i = 0; i < 4; i++) {
		EventsByDayTableViewController *ebdtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByDayVC"];
		[self.viewControllers addObject:ebdtvc];
	}
	
	[self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
	lastIndex = 0;
	self.eventsSegmentedView.selectedSegmentIndex = 0;
	[self eventDayChanged:self.eventsSegmentedView];
	
    [self loadEventsFromApi];
	[self loadScheduleFromApi];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	
    self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self addChildViewController:self.pageViewController];
	
	lastIndex = 0;
	self.eventsSegmentedView.selectedSegmentIndex = 0;
	
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
	self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.definesPresentationContext = NO;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.navigationItem.titleView = self.searchController.searchBar;
}

- (IBAction)eventDayChanged:(id)sender {
    
    NSInteger index = [sender selectedSegmentIndex];
	[self.pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:index]] direction:(lastIndex >= index) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward  animated:YES completion:nil];
	
    lastIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	if (viewController == nil || viewController == self.viewControllers.firstObject) {
		return nil;
	}
	NSInteger index = [self.viewControllers indexOfObject:(EventsByDayTableViewController *)viewController];
	return [self.viewControllers objectAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	if (viewController == nil || viewController == self.viewControllers.lastObject) {
		return nil;
	}
	NSInteger index = [self.viewControllers indexOfObject:(EventsByDayTableViewController *)viewController];
	return [self.viewControllers objectAtIndex:index + 1];
}

#pragma mark - Page view controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	
	if (finished) {
		NSInteger index = [self.viewControllers indexOfObject:(EventsByDayTableViewController *)(pageViewController.viewControllers.lastObject)];
		[self.eventsSegmentedView setSelectedSegmentIndex:index];
	}
	
}

#pragma mark - Search controller

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	UISearchBar *searchBar = self.searchController.searchBar;
	for (EventsByDayTableViewController *ebdtvc in self.viewControllers) {
		[ebdtvc filterWithSearchText:searchBar.text];
	}
}

@end
