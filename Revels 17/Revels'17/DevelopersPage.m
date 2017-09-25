//
//  DevelopersPage.m
//  TechTatva'17
//
//  Created by Abhishek Vora on 19/09/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "DevelopersPage.h"
#import "DevelopersPageCell.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface DevelopersPage ()

@end

@implementation DevelopersPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImageView *headerImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header2"]];
	headerImageView1.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView1.frame = CGRectMake(0, -140, self.view.bounds.size.width, 120);
	headerImageView1.alpha = 0.5;
	[self.tableView addSubview:headerImageView1];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	NSURL *videoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/PyPals/PyPals-Logos/master/Trailer.mp4"];
	AVPlayer *player = [AVPlayer playerWithURL:videoURL];
	AVPlayerViewController *playerViewController = [AVPlayerViewController new];
	playerViewController.player = player;
	[self presentViewController:playerViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DevelopersPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"devCell" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.developerName.text = @"Abhishek Vora";
        cell.devloperImage.image = [UIImage imageNamed:@"Abhishek"];
    }
    else if (indexPath.row == 1) {
        cell.developerName.text = @"Gautam Vinod";
        cell.devloperImage.image = [UIImage imageNamed:@"Gautham"];

    }
    else if (indexPath.row == 2) {
        cell.developerName.text = @"Anurag Choudhary";
        cell.devloperImage.image = [UIImage imageNamed:@"Anurag"];

    }
    else if (indexPath.row == 3) {
        cell.developerName.text = @"Mahima Borah";
        cell.devloperImage.image = [UIImage imageNamed:@"Mahima"];

    }
    else if (indexPath.row == 4) {
        cell.developerName.text = @"Rhitam";
        cell.devloperImage.image = [UIImage imageNamed:@"Rhitam"];

    }
    else if (indexPath.row == 5) {
        cell.developerName.text = @"Krishna Birla";
        cell.devloperImage.image = [UIImage imageNamed:@"Krishna"];

    }
    else if (indexPath.row == 6) {
        cell.developerName.text = @"Anjali Premjit";
        cell.devloperImage.image = [UIImage imageNamed:@"contact"];

    }
    else if (indexPath.row == 7) {
        cell.developerName.text = @"Rahul Sathanapalli";
        cell.devloperImage.image = [UIImage imageNamed:@"Rahul"];

    }
    else if (indexPath.row == 8) {
        cell.developerName.text = @"Reuben Nellissery";
        cell.devloperImage.image = [UIImage imageNamed:@"Reuben"];

    }
    else if (indexPath.row == 9) {
        cell.developerName.text = @"Saptarshi Roy Choudhuri";
        cell.devloperImage.image = [UIImage imageNamed:@"contact"];

    }
    cell.devloperImage.layer.cornerRadius = 30.0;
    cell.devloperImage.layer.masksToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cat Head" message:@"iOS Developer\nFailure is not an option, It comes\nbundled with your Microsoft product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    else if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cat Head" message:@"Windows Developer\nPenguins love cold,\nthey won't survive the sun." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    else if (indexPath.row == 2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cat Head" message:@"Android Developer\nStudent by day.\nDeveloper by night." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
//    else if (indexPath.row == 3) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"iOS Developer\n..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
//    }
//    else if (indexPath.row == 4) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"iOS Developer\n..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
//    }
    else if (indexPath.row == 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"Windows Developer\nEven without the glasses, I can C#" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if (indexPath.row == 6) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"Windows Developer\n..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
//    }
    else if (indexPath.row == 7) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"Android Developer\nFork that shit" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if (indexPath.row == 8) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"Android Developer\n..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
//    }
//    else if (indexPath.row == 9) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Organiser" message:@"Android Developer\n..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
