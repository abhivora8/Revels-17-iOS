//
//  EventsViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 18/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsViewController.h"
#import "EventsTableViewCell.h"

@interface EventsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation EventsViewController{
    NSArray *eventsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Use two NIBs, one for expanded form
	[self.eventsTableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell2" bundle:nil] forCellReuseIdentifier:@"eventsCellExp"];
	[self.eventsTableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"eventsCell"];
    [self eventDayChanged:0];
	
}

- (IBAction)eventDayChanged:(id)sender {
    if(_eventsSegmentedView.selectedSegmentIndex == 0 || sender == 0)
    {
        eventsList = [NSArray arrayWithObjects:@"Day1Eve1",@"Day1Eve2", nil];
        [self.eventsTableView reloadData];
    }
    
    else if(_eventsSegmentedView.selectedSegmentIndex == 1)
    {
        eventsList = [NSArray arrayWithObjects:@"Day2Eve1",@"Day2Eve2", nil];
        [self.eventsTableView reloadData];
    }
    else if(_eventsSegmentedView.selectedSegmentIndex == 2)
    {
        eventsList = [NSArray arrayWithObjects:@"Day3Eve1",@"Day3Eve2", nil];
        [self.eventsTableView reloadData];
    }
    else if(_eventsSegmentedView.selectedSegmentIndex == 3)
    {
        eventsList = [NSArray arrayWithObjects:@"Day4Eve1",@"Day4Eve2", nil];
        [self.eventsTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	EventsTableViewCell *cell;
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCellExp"];
	else
		cell = (EventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventsCell"];
	
    cell.eveName = [eventsList objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return eventsList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView beginUpdates]; // Call this before making changes like row height update to the table view
	
    if (!([indexPath compare:self.selectedIndexPath] == NSOrderedSame))
        self.selectedIndexPath = indexPath;
    else
        self.selectedIndexPath = nil;
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[tableView reloadData]; // Reload after allowing the transistion to finish.
		[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	});
	
	[tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
        return 300.f;
    return 75.f;
}


@end
