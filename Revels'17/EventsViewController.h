//
//  EventsViewController.h
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *eventsSegmentedView;

@property (strong, nonatomic) IBOutlet UITableView *eventsTableView;

@end
