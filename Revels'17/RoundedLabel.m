//
//  RoundedLabel.m
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "RoundedLabel.h"

@implementation RoundedLabel

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [bezierPath setLineWidth:1.f];
    [self.fillColor setFill];
    [bezierPath fill];
    
    [super drawRect:rect];
    
}

@end
