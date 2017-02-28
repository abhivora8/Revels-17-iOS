//
//  WorkshopsTableViewCell.h
//  Revels'17
//
//  Created by Avikant Saini on 2/27/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkshopsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *wnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wvenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wcontactLabel;
@property (weak, nonatomic) IBOutlet UILabel *wcostLabel;

@property (weak, nonatomic) IBOutlet UIButton *winfoButton;
@property (weak, nonatomic) IBOutlet UIButton *wcallButton;

@end
