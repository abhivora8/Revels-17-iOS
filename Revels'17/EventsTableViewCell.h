//
//  EventsTableViewCell.h
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eveName;
@property (strong, nonatomic) IBOutlet UILabel *catName;

- (IBAction)infoButton:(id)sender;
- (IBAction)favouritesButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UIImageView *dateimage;
@property (strong, nonatomic) IBOutlet UIImageView *maxPplImage;
@property (strong, nonatomic) IBOutlet UIImageView *personImage;

@property (strong, nonatomic) IBOutlet UIImageView *contactImage;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxPplLabel;
@property (strong, nonatomic) IBOutlet UILabel *personOfContactLabel;

@end
