//
//  EventsByDayTableViewController.h
//  Revels'17
//
//  Created by Avikant Saini on 2/2/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsByDayTableViewController : UITableViewController

// Make this array of the model objects later.
@property (nonatomic) NSArray <ScheduleStore *> *schedules;

@end
