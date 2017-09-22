//
//  WorkshopsTableViewController.m
//  Revels'17
//
//  Created by Avikant Saini on 2/27/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "WorkshopsTableViewController.h"
#import "WorkshopsTableViewCell.h"
#import "WorkshopsModel.h"

@interface WorkshopsTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic) NSArray <WorkshopsModel *> *workshops;

@end

@implementation WorkshopsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"WorkshopsTableViewCell" bundle:nil] forCellReuseIdentifier:@"wcell"];
	
	self.workshops = [NSArray new];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
	
	[self loadWorkshopsData];
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	headerImageView.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView.frame = CGRectMake(0, -120, self.view.bounds.size.width, 80);
	headerImageView.alpha = 0.5;
	[self.tableView addSubview:headerImageView];
    
}

- (void)loadWorkshopsData {
	
	SVHUD_SHOW;
	
	[[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://api.mitportals.in/workshops/"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		SVHUD_HIDE;
		
		if (data != nil) {
			
			@try {
				NSError *err2;
				id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err2];
				if (err2 == nil) {
					self.workshops = [WorkshopsModel getAllWorkshopsFromJSONArray:[jsonData objectForKey:@"data"]];
                    
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.tableView reloadData];
					});
				}
			} @catch (NSException *exception) {
				SVHUD_FAILURE(@"Error");
			}
			
		}
		
	}] resume];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.workshops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkshopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wcell" forIndexPath:indexPath];
    
	WorkshopsModel *wshop = [self.workshops objectAtIndex:indexPath.row];
	
	cell.wnameLabel.text = wshop.wname;
	cell.wdateLabel.text = [NSString stringWithFormat:@"%@, %@ - %@", wshop.wdate, wshop.wshuru, wshop.wkhatam];
    if ([wshop.wcost length] == 0) {
        wshop.wcost = [NSString stringWithFormat:@"Free"];
    }
    else{
        cell.wcostLabel.text = wshop.wcost;
    }
	cell.wcostLabel.text = wshop.wcost;
	cell.wcontactLabel.text = wshop.cname;
	cell.wvenueLabel.text = wshop.wvenue;
	
	cell.winfoButton.tag = indexPath.row;
	cell.wcallButton.tag = indexPath.row;
    if (wshop.wnumb == nil) {
        cell.wcontactLabel.text = [NSString stringWithFormat: @"Not available"];
    }
//    cell.wcontactLabel.text = [NSString stringWithFormat: @"Not available"];
	
	[cell.winfoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
	[cell.wcallButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
	
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 216.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 4.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
	return 4.f;
}

- (void)infoAction:(id)sender {
	NSInteger row = [sender tag];
	WorkshopsModel *wshop = [self.workshops objectAtIndex:row];
    if ([wshop.wdesc length] == 0) {
        wshop.wdesc = [NSString stringWithFormat:@"Sorry.\nNo desc available."];
    }
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", wshop.wname] message:[NSString stringWithFormat:@"%@", wshop.wdesc] preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)callAction:(id)sender {
	NSInteger row = [sender tag];
	WorkshopsModel *wshop = [self.workshops objectAtIndex:row];
	NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [wshop.wnumb stringByReplacingOccurrencesOfString:@" " withString:@""]]];
	[[UIApplication sharedApplication] openURL:callURL];
}

#pragma mark - DZN Empty Data Set Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"RevelsCircle"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
	return GLOBAL_BACK_COLOR;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = [NSString stringWithFormat:@"No workshops found. Blame it on WebSys."];
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Neutraface2Display-Bold" size:24.f],
								 NSForegroundColorAttributeName: GLOBAL_RED_COLOR};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
	return (self.workshops.count == 0);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
