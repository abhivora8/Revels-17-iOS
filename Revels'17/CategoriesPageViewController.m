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


@end

@implementation CategoriesPageViewController
{
    NSInteger lastIndex;
    NSMutableArray *eveArray;
    NSMutableArray * eventDetailsToDisplay;
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
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
                eveArray = [EventsDetailsJSONModel getArrayFromJson:array];
                
                for (NSInteger i = 0; i < 4; i++)
                {
                    EventsTableViewController *etvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsByCatVC"];
                    
                    NSMutableArray *events = [NSMutableArray new];
                    
                    for(EventsDetailsJSONModel *x in eveArray)
                    {
                        if([x.categoryEventName isEqualToString:self.catName] && [x.day isEqualToString:[NSString stringWithFormat:@"%ld",i+1]])
                        {
                            [events addObject:x.eventName];
                            [eventDetailsToDisplay addObject:x];
                        }
                    }
                    NSLog(@"Events:%@",events);
                    
                    etvc.eventList = events;
                    etvc.catName = self.catName;
                    etvc.eventDetails = eventDetailsToDisplay;
                    [self.viewControllers addObject:etvc];
                }
                
                [self addChildViewController:self.pageViewController];
                
                lastIndex = 0;
                self.eventsByDaySegmentedView.selectedSegmentIndex = 0;
                
                [self dayChanged:self.eventsByDaySegmentedView];
                
                [self.pageViewController setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    });
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    eventDetailsToDisplay = [NSMutableArray new];
    [self loadEventsFromApi];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.viewControllers = [NSMutableArray new];
    
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
