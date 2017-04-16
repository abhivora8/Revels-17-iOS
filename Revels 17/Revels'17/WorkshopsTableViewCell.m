//
//  WorkshopsTableViewCell.m
//  Revels'17
//
//  Created by Avikant Saini on 2/27/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "WorkshopsTableViewCell.h"

@implementation WorkshopsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:CGRectInset(frame, 8, 4)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
