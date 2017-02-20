//
//  DAHexagonalView.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

IB_DESIGNABLE

@protocol DAHexagonalViewDelegate <NSObject>

- (void)hexagonalViewButtonPressedAtIndex:(NSInteger)index;
- (void)finishedDeveloperAnimations;
- (void)finishedAllAnimationsDoSomethingAwesome;

@end

@interface DAHexagonalView : UIView

@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *entryPoints;
@property (nonatomic, strong) NSMutableArray *hexPoints;
@property (nonatomic, strong) NSMutableArray *exitPoints;

@property (nonatomic) CGPoint actualCenter;

@property (nonatomic, strong) NSMutableArray <UIImage *> *images;

@property (nonatomic, weak) id<DAHexagonalViewDelegate> delegate;

- (void)animatePath;

- (void)removeAllAnimations;

- (void)drawTopText:(NSString *)text withAttributes:(NSDictionary *)attributes;
- (void)drawBottomText:(NSString *)text withAttributes:(NSDictionary *)attributes;

@end
