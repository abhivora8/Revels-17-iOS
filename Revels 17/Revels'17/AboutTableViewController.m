//
//  AboutTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@property (strong, nonatomic) UIView *bottomBackgroundView;

@end

@implementation AboutTableViewController {
    Reachability *reachability;
    
    NSString *finalWebsiteUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.tableView.backgroundColor = GLOBAL_GRAY_COLOR;
	self.view.backgroundColor = GLOBAL_GRAY_COLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!self.bottomBackgroundView) {
        
        CGRect barRect = CGRectMake(0.0f, SHeight - 32.f, SWdith, 32.0f);
        
        self.bottomBackgroundView = [[UIView alloc] initWithFrame:barRect];
        self.bottomBackgroundView.backgroundColor = GLOBAL_BACK_COLOR;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        NSArray *colors = @[(id)[[UIColor colorWithWhite:0.8 alpha:0] CGColor],
                            (id)[[UIColor colorWithWhite:1.0 alpha:1] CGColor]];
        [gradientLayer setColors:colors];
        [gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradientLayer setEndPoint:CGPointMake(0.0f, 1.f)];
        [gradientLayer setFrame:[self.bottomBackgroundView bounds]];
        
        [[self.bottomBackgroundView layer] setMask:gradientLayer];
        [self.navigationController.view addSubview:self.bottomBackgroundView];
    }
    
}

#pragma mark - Sharing

- (void)openURLWithString:(NSString *)URLString backupURLString:(NSString *)backupURLString {
    reachability = [Reachability reachabilityForInternetConnection];
    if (reachability.isReachable) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URLString]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        else
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:backupURLString]];
    }
    else {
        SVHUD_FAILURE(@"No connection!");
    }
}

- (IBAction)facebookAction:(id)sender {
    [self openURLWithString:@"https://www.facebook.com/mittechtatva/" backupURLString:@"http://www.facebook.com/mittechtatva"];
}

- (IBAction)twitterAction:(id)sender {
    [self openURLWithString:@"twitter://user?screen_name=mittechtatva/" backupURLString:@"http://www.twitter.com/mittechtatva"];
}

- (IBAction)instagramAction:(id)sender {
    [self openURLWithString:@"instagram://user?username=mittechtatva" backupURLString:@"http://www.instagram.com/mittechtatva"];
}

- (IBAction)youtubeAction:(id)sender {
    [self openURLWithString:@"youtube://www.youtube.com/channel/UC9gwWd47a0q042qwEgutjWw" backupURLString:@"http://www.youtube.com/user/UC9gwWd47a0q042qwEgutjWw"];
}

- (IBAction)snapchatAction:(id)sender {
    [self openURLWithString:@"snapchat://add/techtatva" backupURLString:@"http://www.snapchat.com/add/techtatva/"];
}

- (IBAction)browserAction:(id)sender {
    
    SVHUD_SHOW;
	
}

- (IBAction)sharesheetAction:(id)sender {
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.mitrevels.in"];
    NSString *textToShare = @"Revels is one of the most awaited cultural and sports festival in the south circuit amongst the engineering colleges and is widely regarded as the largest event in Karnataka.";
    //    UIImage *imageToShare = [UIImage imageNamed:@"RevelsCircle"];
    NSArray *activityItems = @[textToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


#pragma mark - Table view data source

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


@end
