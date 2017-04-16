//
//  SplashViewController.m
//  Revels'17
//
//  Created by Avikant Saini on 2/28/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

@import MediaPlayer;

#import "SplashViewController.h"

@interface SplashViewController () <UIGestureRecognizerDelegate>

@property (nonatomic) MPMoviePlayerController *moviePlayerController;

@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SplashViewController {
	BOOL present;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	present = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerController];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	NSString *stringPath;
	stringPath = [[NSBundle mainBundle] pathForResource:@"RevelsIntro" ofType:@"mp4"];
	NSURL *fileUrl = [NSURL fileURLWithPath:stringPath];
	self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileUrl];
	[self.moviePlayerController setMovieSourceType:MPMovieSourceTypeFile];
	[self.moviePlayerController.view setFrame:self.view.frame];
	[self.moviePlayerController setFullscreen:YES];
	[self.moviePlayerController setScalingMode:MPMovieScalingModeFill];
	[self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
	[self.view insertSubview:self.moviePlayerController.view atIndex:0];

	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	self.tapGestureRecognizer.delegate = self;
	[self.view addGestureRecognizer:self.tapGestureRecognizer];
	
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.moviePlayerController play];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
	[self playbackFinished];
}

- (void)playbackFinished {
	if (present) {
		UITabBarController *tabBarC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
		[self presentViewController:tabBarC animated:YES completion:^{
			self.view.window.rootViewController = tabBarC;
		}];
		present = NO;
	}
}

#pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
