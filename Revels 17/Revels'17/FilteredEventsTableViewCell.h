//
//  FilteredEventsTableViewCell.h
//  Revels'17
//
//  Created by Abhishek Vora on 28/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteredEventsTableViewCell : UITableViewCell

@property (nonatomic) NSString *day;

@property (strong, nonatomic) IBOutlet UILabel *eveName;
@property (strong, nonatomic) IBOutlet UILabel *catName;
@property (strong, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *dateImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *maxPplImage;
@property (strong, nonatomic) IBOutlet UILabel *maxPplLabel;
@property (strong, nonatomic) IBOutlet UIImageView *contactImage;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;

@end
