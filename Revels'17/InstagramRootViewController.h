//
//  InstagramRootViewController.h
//  Revels'17
//
//  Created by Abhishek Vora on 21/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramData.h"
#import "InstagramDetailViewController.h"

@interface InstagramRootViewController : UIViewController

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) NSMutableArray <InstagramData *> *instagramObjects;
@property (nonatomic) NSInteger presentationIndex;

- (InstagramDetailViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
