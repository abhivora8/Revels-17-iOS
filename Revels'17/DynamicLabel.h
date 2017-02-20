//
//  DynamicLabel.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicLabelDelegate <NSObject>

- (void)didFinishTextAnimation;

@end

@interface DynamicLabel : UILabel

@property IBInspectable CGFloat lineWidth;

@property IBInspectable CGFloat wordSpeed;

@property (weak, nonatomic) id<DynamicLabelDelegate> delegate;

- (void)setDefaultText:(NSString *)text;

@end
