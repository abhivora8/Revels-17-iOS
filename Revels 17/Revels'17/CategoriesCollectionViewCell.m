//
//  CategoriesCollectionViewCell.m
//  Revels'17
//
//  Created by Avikant Saini on 2/26/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "CategoriesCollectionViewCell.h"

@implementation CategoriesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	if (highlighted) {
		self.backgroundColor = [UIColor darkGrayColor];
	} else {
		self.backgroundColor = GLOBAL_GRAY_COLOR;
	}
}

@end
