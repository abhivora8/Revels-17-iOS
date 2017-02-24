//
//  EventsTableViewCell.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsTableViewCell.h"

@implementation EventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)infoButton:(id)sender {
}

- (void)setDay:(NSString *)day {
    _day = day;
    if ([day isEqualToString:@"1"])
        self.dateLabel.text = [NSString stringWithFormat:@"Wednesday, March 8th"];
    else if ([day isEqualToString:@"2"])
        self.dateLabel.text = [NSString stringWithFormat:@"Thursday, March 9th"];
    else if ([day isEqualToString:@"3"])
        self.dateLabel.text = [NSString stringWithFormat:@"Friday, March 10th"];
    else if ([day isEqualToString:@"4"])
        self.dateLabel.text = [NSString stringWithFormat:@"Saturday, March 11th"];
}


- (IBAction)favouritesButton:(id)sender {
}
@end
