//
//  FilteredEventsTableViewCell.h
//  Revels'17
//
//  Created by Abhishek Vora on 28/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteredEventsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *eveImage;
@property (strong, nonatomic) IBOutlet UILabel *eveName;
@property (strong, nonatomic) IBOutlet UIButton *favButton;
- (IBAction)FavButtonPressed:(id)sender;

@end
