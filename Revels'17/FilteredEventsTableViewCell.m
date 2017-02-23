//
//  FilteredEventsTableViewCell.m
//  Revels'17
//
//  Created by Abhishek Vora on 28/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "FilteredEventsTableViewCell.h"

@implementation FilteredEventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)setFrame:(CGRect)frame {
	[super setFrame:CGRectInset(frame, 8, 4)];
}

@end
