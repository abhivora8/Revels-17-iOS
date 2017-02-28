//
//  InstagramRootViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 21/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "InstagramRootViewController.h"
#import "UIImage+ImageEffects.h"
#import "CrossButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface InstagramRootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet CrossButton *crossButton;

@end

@implementation InstagramRootViewController {
    Reachability *reachability;
    UIPanGestureRecognizer *panGestureRecognizer;
    UISwipeGestureRecognizer *swipeGesture;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    InstagramDetailViewController *idvc = [self viewControllerAtIndex:self.presentationIndex];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramPageVC"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.pageViewController.view.frame = CGRectMake(0, 0, SWdith, SHeight);
    
    [self.pageViewController setViewControllers:@[idvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view aboveSubview:self.backgroundImageView];
    [self.pageViewController didMoveToParentViewController:self];
    
    InstagramData *instaData = [self.instagramObjects objectAtIndex:self.presentationIndex];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:instaData.lowResURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [image applyDarkEffect];
        });
    }];
    
    // Parallax
    UIInterpolatingMotionEffect* horinzontalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horinzontalMotionEffectBg.minimumRelativeValue = @(10);
    horinzontalMotionEffectBg.maximumRelativeValue = @(-10);
    [self.backgroundImageView addMotionEffect:horinzontalMotionEffectBg];
    
    UIInterpolatingMotionEffect* verticalMotionEffectBg = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffectBg.minimumRelativeValue = @(10);
    verticalMotionEffectBg.maximumRelativeValue = @(-10);
    [self.backgroundImageView addMotionEffect:verticalMotionEffectBg];
    
    reachability = [Reachability reachabilityWithHostName:@"http://www.google.com"];
    
    //	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    //	[self.view addGestureRecognizer:panGestureRecognizer];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGesture];
	
	[UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.crossButton.alpha = 0.2;
	} completion:nil];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (InstagramDetailViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    InstagramDetailViewController *idvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramDetailVC"];
    
    InstagramData *instaData = [self.instagramObjects objectAtIndex:index];
    idvc.instaData = instaData;
    idvc.pageIndex = index;
    idvc.reachability = reachability;
    
    return idvc;
}

- (IBAction)dismissController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gesture recognizers

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer {
    [self dismissController:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint location = [recognizer locationInView:self.view];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, location.y);
    
}

#pragma mark - Page view controller data source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = ((InstagramDetailViewController *)viewController).pageIndex;
    
    if (index == 0 || index == NSNotFound)
        return nil;
    
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = ((InstagramDetailViewController *)viewController).pageIndex;
    
    if (index == self.instagramObjects.count - 1 || index == NSNotFound)
        return nil;
    
    return [self viewControllerAtIndex:index + 1];
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//	return self.instagramObjects.count;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//	return self.presentationIndex;
//}

#pragma mark - Page view controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    InstagramDetailViewController *idvc = [pageViewController.viewControllers firstObject];
    NSInteger index = idvc.pageIndex;
    InstagramData *instaData = [self.instagramObjects objectAtIndex:index];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:instaData.thumbnailURL options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = [image applyDarkEffect];
        });
    }];
	[UIView animateWithDuration:0.3 animations:^{
		self.crossButton.alpha = 1.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.3 animations:^{
			self.crossButton.alpha = 0.2;
		} completion:nil];
	}];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
