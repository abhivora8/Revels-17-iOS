//
//  MoreTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

@import SafariServices;

#import "MoreTableViewController.h"
#import <KWTransition/KWTransition.h>
#import "AboutBackgroundView.h"

@interface MoreTableViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;

@end

@implementation MoreTableViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transition = [KWTransition manager];
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	headerImageView.contentMode = UIViewContentModeScaleAspectFit;
	self.tableView.tableHeaderView = headerImageView;
	
	self.title = @"";
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
	
}


- (void)viewDidDisappear:(BOOL)animated {
	
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Animate cells
    
    if (indexPath.section == 0)
        return;
    
    if (indexPath.section == 1)
        cell.layer.transform = CATransform3DScale(CATransform3DMakeTranslation(0, (indexPath.row % 2 == 0)?20:-20, 0), 0.8, 0.8, 0.8);
    else
        cell.layer.transform = CATransform3DScale(CATransform3DMakeTranslation((indexPath.section % 2 == 0)?80:-80, 0, 0), 0.8, 0.8, 0.8);
    
    cell.alpha = 0.0;
    
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UINavigationController *navc;
    
    if (indexPath.section == 0) {
        
        // Register shit
        
		SFSafariViewController *rwvc;
        
        if (indexPath.row == 0) {
//            rwvc.passedTitle = @"Register for Proshow";
            rwvc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://http://techtatva.in"]];
        }
		
		[self.navigationController presentViewController:rwvc animated:YES completion:nil];
		
		return;
        
    } else if (indexPath.section == 1) {
        
        // About Revels
        
        navc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutVCNav"];
        
    } else if (indexPath.section == 2) {
        
        // Workshops
        
        navc = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkshopsVCNav"];
        
    } else if (indexPath.section == 3) {
        
        // Favourites
        
        navc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesVCNav"];
        
    } else if (indexPath.section == 4) {
        
        // Developers
        
        navc = [self.storyboard instantiateViewControllerWithIdentifier:@"DevelopersVCNav"];
        
    }
    
    self.transition.style = KWTransitionStyleFadeBackOver;
    
    [navc setTransitioningDelegate:self];
    
    [self.navigationController presentViewController:navc animated:YES completion:nil];
    
}

#pragma mark - View controller animated transistioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    self.transition.action = KWTransitionStepPresent;
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.action = KWTransitionStepDismiss;
    return self.transition;
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
