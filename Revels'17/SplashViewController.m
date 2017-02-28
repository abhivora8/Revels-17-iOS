//
//  SplashViewController.m
//  Revels'17
//
//  Created by Avikant Saini on 2/28/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

@import MediaPlayer;

#import "SplashViewController.h"

@interface SplashViewController ()

@property (nonatomic) MPMoviePlayerController *moviePlayerController;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
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
	[self.view addSubview:self.moviePlayerController.view];
	[self.moviePlayerController play];

	
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)playbackFinished {
	UITabBarController *tabBarC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
	[self presentViewController:tabBarC animated:YES completion:^{
		self.view.window.rootViewController = tabBarC;
	}];
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
