//
//  SportsResultsTableViewController.h
//  Revels'17
//
//  Created by Avikant Saini on 2/28/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsResultsTableViewController : UITableViewController

@property (nonatomic) NSArray <EventStore *> *events;
@property (nonatomic) NSArray *allResults;

- (void)filterResultsWithSearchText:(NSString *)searchText;

@end
