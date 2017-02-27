//
//  CategoriesPageViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 20/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "CategoriesPageViewController.h"
#import "EventsTableViewController.h"
#import "EventsDetailsJSONModel.h"

@interface CategoriesPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *eventsByDaySegmentedView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSMutableArray <EventsTableViewController *> *viewControllers;

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *eventRequest;
@property (nonatomic) NSFetchRequest *scheduleRequest;


@end

@implementation CategoriesPageViewController {
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
				[eveArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@", self.category.catID]];
				
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
				[scheduleArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@", self.category.catID]];
				
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
		EventsTableViewController *ebdtvc = [self.viewControllers objectAtIndex:i];
		NSArray *filteredSchedules = [scheduleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", [NSString stringWithFormat:@"%li", i + 1]]];
		ebdtvc.catName = self.category.catName;
		ebdtvc.schedules = filteredSchedules;
	}
	EventsTableViewController *etvc = [self.viewControllers firstObject];
	[etvc.tableView reloadData];
	[self dayChanged:self.eventsByDaySegmentedView];
	
}


- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.title = self.category.catName;
	
	self.context = [AppDelegate sharedManagedObjectContext];
	
	self.eventRequest = [EventStore fetchRequest];
	[self.eventRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]]];
	[self.eventRequest setPredicate:[NSPredicate predicateWithFormat:@"catID == %@", self.category.catID]];
	
	self.scheduleRequest = [ScheduleStore fetchRequest];
	[self.scheduleRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stime" ascending:YES]]];
	[self.scheduleRequest setPredicate:[NSPredicate predicateWithFormat:@"catID == %@", self.category.catID]];
	
	eveArray = [NSMutableArray new];
	scheduleArray = [NSMutableArray new];
	
	NSError *error;
	
	eveArray = [[self.context executeFetchRequest:self.eventRequest error:&error] mutableCopy];
	scheduleArray = [[self.context executeFetchRequest:self.scheduleRequest error:&error] mutableCopy];
	
	self.viewControllers = [NSMutableArray new];
	
	for (NSInteger i = 0; i < 4; i++) {
		EventsTableViewController *ebdtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByCatVC"];
		[self.viewControllers addObject:ebdtvc];
	}
	
	[self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
	lastIndex = 0;
	self.eventsByDaySegmentedView.selectedSegmentIndex = 0;
	[self dayChanged:self.eventsByDaySegmentedView];

	
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self addChildViewController:self.pageViewController];
	
	lastIndex = 0;
	self.eventsByDaySegmentedView.selectedSegmentIndex = 0;
	
	if (eveArray.count == 0 || scheduleArray.count == 0) {
		SVHUD_SHOW;
	} else {
		[self populateChildControllers];
	}

	[self loadEventsFromApi];
	[self loadScheduleFromApi];
	
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.containerView addSubview:self.pageViewController.view];
    [self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.pageViewController.view.frame = self.containerView.bounds;
    self.pageViewController.view.clipsToBounds = YES;
    
    [self.pageViewController didMoveToParentViewController:self];
    
}


- (IBAction)dayChanged:(id)sender {
    
    NSInteger index = [sender selectedSegmentIndex];
    [self.pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:index]] direction:(lastIndex >= index) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    lastIndex = index;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == nil || viewController == self.viewControllers.firstObject) {
        return nil;
    }
    NSInteger index = [self.viewControllers indexOfObject:(EventsTableViewController *)viewController];
    return [self.viewControllers objectAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == nil || viewController == self.viewControllers.lastObject) {
        return nil;
    }
    NSInteger index = [self.viewControllers indexOfObject:(EventsTableViewController *)viewController];
    return [self.viewControllers objectAtIndex:index + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (finished) {
        NSInteger index = [self.viewControllers indexOfObject:(EventsTableViewController *)(pageViewController.viewControllers.lastObject)];
        [self.eventsByDaySegmentedView setSelectedSegmentIndex:index];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
