//
//  ResultsTableViewCell.h
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventName;

@property (strong, nonatomic) IBOutlet UILabel *categoryName;

@property (strong, nonatomic) IBOutlet UILabel *round;

@end
