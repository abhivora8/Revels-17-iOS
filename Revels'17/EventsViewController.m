//
//  EventsViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsViewController.h"

#import "EventsByDayTableViewController.h"

@interface EventsViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UISegmentedControl *eventsSegmentedView;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSMutableArray <EventsByDayTableViewController *> *viewControllers;

@end

@implementation EventsViewController {
	NSInteger lastIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
															  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
																			options:nil];
	
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	self.viewControllers = [NSMutableArray new];
	for (NSInteger i = 0; i < 4; ++i) {
		EventsByDayTableViewController *ebdtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByDayVC"];
		NSMutableArray <NSString *> *events = [NSMutableArray new];
		for (NSInteger j = 0; j < rand() % 5 + 5; ++j) {
			[events addObject:[NSString stringWithFormat:@"Event %li.%li", i, j]];
		}
		ebdtvc.events = events;
		[self.viewControllers addObject:ebdtvc];
	}
	
	[self addChildViewController:self.pageViewController];
	
	lastIndex = 0;
	self.eventsSegmentedView.selectedSegmentIndex = 0;
    [self eventDayChanged:self.eventsSegmentedView];
	
	[self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[self.containerView addSubview:self.pageViewController.view];
	[self.pageViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
	self.pageViewController.view.frame = self.containerView.bounds;
	self.pageViewController.view.clipsToBounds = YES;
	
	[self.pageViewController didMoveToParentViewController:self];
	
	
}

- (IBAction)eventDayChanged:(id)sender {
	NSInteger index = [sender selectedSegmentIndex];
	[self.pageViewController setViewControllers:@[[self.viewControllers objectAtIndex:index]]
									  direction:(lastIndex >= index) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
									   animated:YES
									 completion:nil];
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

@end
