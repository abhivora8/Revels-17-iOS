//
//  EventsTableViewController.h
//  Revels'17
//
//  Created by Abhishek Vora on 26/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewController : UITableViewController

@property (nonatomic,strong) NSString *catName;
@property (nonatomic,strong) NSArray *eventList;
@property (nonatomic,strong) NSArray *eventDetails;

@end
