//
//  SportsResultsTableViewController.m
//  Revels'17
//
//  Created by Avikant Saini on 2/28/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "SportsResultsTableViewController.h"
#import "ResultsTableViewCell.h"
#import "SportsDetailsJSONModel.h"

@interface SportsResultsTableViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic) NSMutableArray *filteredResults;

@end

@implementation SportsResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.filteredResults = [self.allResults mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:@"resultsCell"];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	headerImageView.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView.frame = CGRectMake(0, -120, self.view.bounds.size.width, 80);
	headerImageView.alpha = 0.5;
	[self.tableView addSubview:headerImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.filteredResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ResultsTableViewCell *cell;
	SportsDetailsJSONModel *model = [self.filteredResults objectAtIndex:indexPath.row];
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
	
	cell.eventName.text = [NSString stringWithFormat:@"%@ (%@)", model.eventName.uppercaseString, model.round];
	cell.categoryName.text = [NSString stringWithFormat:@"Day: %@", model.day];
	cell.teamIDLabel.text = [NSString stringWithFormat:@"Team: %@", model.teamID];
	cell.posLabel.text = [NSString stringWithFormat:@"Pos: %@", model.pos];
	
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64.f;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark - DZN Empty Data Set Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"RevelsCircle"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
	return GLOBAL_BACK_COLOR;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = [NSString stringWithFormat:@"Patience my child.\nResults are not out yet."];
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Neutraface2Display-Bold" size:24.f],
								 NSForegroundColorAttributeName: GLOBAL_RED_COLOR};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
	return (self.allResults.count == 0);
}

#pragma mark - Other

- (void)filterResultsWithSearchText:(NSString *)searchText {
	self.filteredResults = [self.allResults mutableCopy];
	if (searchText.length > 0) {
		[self.filteredResults filterUsingPredicate:[NSPredicate predicateWithFormat:@"eventName contains[cd] %@ OR teamID contains[cd] %@", searchText, searchText]];
	}
	[self.tableView reloadData];
}

@end
