//
//  FavouritesTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 27/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "FavouritesTableViewController.h"
#import "EventsTableViewCell.h"
#import "EventsDetailsJSONModel.h"
#import "EventStore+CoreDataClass.h"
#import "ScheduleStore+CoreDataClass.h"

@interface FavouritesTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *fetchRequest;
@property (nonatomic) NSFetchRequest *fetchSchedule;

@end

@implementation FavouritesTableViewController
{
    NSMutableArray *eveArray;
    NSMutableArray *scheduleArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
    
    self.context = [AppDelegate sharedManagedObjectContext];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell2" bundle:nil] forCellReuseIdentifier:@"favsCell"];
    
    self.fetchRequest = [EventStore fetchRequest];
    [self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]]];
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isFavorite == 1"]];
    
    self.fetchSchedule = [ScheduleStore fetchRequest];
    [self.fetchSchedule setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stime" ascending:YES]]];
    
    [self fetchFavourites];
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
    return scheduleArray.count;
}

- (void)fetchFavourites {
    NSError *error;
	eveArray = [NSMutableArray new];
	scheduleArray = [NSMutableArray new];
    eveArray = [[self.context executeFetchRequest:self.fetchRequest error:&error] mutableCopy];
    NSMutableArray *schArray = [[self.context executeFetchRequest:self.fetchSchedule error:&error] mutableCopy];
	for (EventStore *event in eveArray) {
		NSArray *fsch = [schArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eventID == %@", event.eventID]];
		[scheduleArray addObjectsFromArray:fsch];
		[schArray removeObjectsInArray:fsch];
	}
	if (error) {
        NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
    [self.tableView reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventsTableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"favsCell" forIndexPath:indexPath];
    
    ScheduleStore *schedule = [scheduleArray objectAtIndex:indexPath.row];
    EventStore *event = [[eveArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	
	cell.roundedCorners = YES;
    
    cell.catName.text = [NSString stringWithFormat:@"%@", event.catName];
    cell.eveName.text = [NSString stringWithFormat:@"%@ %@", event.eventName, ([schedule.round isEqualToString:@"-"])?@"":[NSString stringWithFormat:@"(%@)", schedule.round]];
    cell.maxPplLabel.text = [NSString stringWithFormat:@"Max team size: %@", event.eventMaxTeamSize];
    
    cell.day = schedule.day;
    cell.locationLabel.text = schedule.venue;
    cell.personOfContactLabel.text = event.contactName;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", schedule.stime, schedule.etime];
    cell.favButton.imageView.image = [UIImage imageNamed:@"favsFilled"];
	
	cell.catImageView.image = [UIImage imageNamed:event.catName];
	
	cell.favButton.tag = indexPath.row;
    
    [cell.favButton addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 232.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4.f;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return GLOBAL_BACK_COLOR;
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    
}

- (void)favAction:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    ScheduleStore *schedule = [scheduleArray objectAtIndex:indexPath.row];
	EventStore *event = [[eveArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	NSArray *favoritedSchedules = [scheduleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", event.catID, event.eventID]];
	NSMutableArray *indexPaths = [NSMutableArray new];
	for (ScheduleStore *sstore in favoritedSchedules) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:[scheduleArray indexOfObject:sstore] inSection:0]];
	}
	[scheduleArray removeObjectsInArray:favoritedSchedules];
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
	event.isFavorite = NO;
	NSError *error;
	[self.context save:&error];
//	SVHUD_SHOW;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		SVHUD_HIDE;
		[self fetchFavourites];
	});
}

- (void)infoAction:(id)sender {
    ScheduleStore *schedule = [scheduleArray objectAtIndex:self.selectedIndexPath.row];
    EventStore *event = [[eveArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
    
    if ([event.eventDesc length] == 4) {//default value in event.desc is "desc" in the api
        event.eventDesc = [NSString stringWithFormat:@"Sorry\nDescription not available."];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", event.eventName] message:[NSString stringWithFormat:@"%@", event.eventDesc] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callAction:(id)sender {
    NSInteger row = [sender tag];
    ScheduleStore *schedule = [scheduleArray objectAtIndex:row];
    EventStore *event = [[eveArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
    NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [event.contactNumber stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    [[UIApplication sharedApplication] openURL:callURL];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
