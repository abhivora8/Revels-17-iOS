//
//  EventsTableViewCell.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsTableViewCell.h"

@implementation EventsTableViewCell

- (void)setFrame:(CGRect)frame {
	if (self.roundedCorners) {
		self.layer.cornerRadius = 4.f;
		self.clipsToBounds = YES;
		self.contentView.layer.cornerRadius = 4.f;
		self.contentView.clipsToBounds = YES;
		[super setFrame:CGRectInset(frame, 8, 4)];
	} else {
		[super setFrame:frame];
	}
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

@end
