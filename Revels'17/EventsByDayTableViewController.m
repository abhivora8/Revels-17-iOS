//
//  EventsByDayTableViewController.m
//  Revels'17
//
//  Created by Avikant Saini on 2/2/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsByDayTableViewController.h"
#import "EventsTableViewCell.h"
#import "EventsDetailsJSONModel.h"

@interface EventsByDayTableViewController ()

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSArray <EventStore *> *events;

@end

@implementation EventsByDayTableViewController {
	BOOL shouldAnimate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell2" bundle:nil] forCellReuseIdentifier:@"cellExp"];
	
	self.selectedIndexPath = nil;
	
	self.context = [AppDelegate sharedManagedObjectContext];
	
	NSError *error;
	self.events = [self.context executeFetchRequest:[EventStore fetchRequest] error:&error];
	
	shouldAnimate = YES;
	
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
    return [self.schedules count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	EventsTableViewCell *cell;
	
	ScheduleStore *schedule = [self.schedules objectAtIndex:indexPath.row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
 
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"cellExp" forIndexPath:indexPath];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	}
	
	cell.catName.text = event.catName;
	cell.eveName.text = [NSString stringWithFormat:@"%@ %@", event.eventName, ([schedule.round isEqualToString:@"-"])?@"":[NSString stringWithFormat:@"(%@)", schedule.round]];
	cell.maxPplLabel.text = [NSString stringWithFormat:@"Max team size: %@", event.eventMaxTeamSize];
	
	cell.day = schedule.day;
	cell.locationLabel.text = schedule.venue;
	cell.personOfContactLabel.text = event.contactName;
	cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", schedule.stime, schedule.etime];
	
	cell.favButton.tag = indexPath.row;
	cell.infoButton.tag = indexPath.row;
	cell.callButton.tag = indexPath.row;
	
	if (event.isFavorite) {
		[cell.favButton setImage:[UIImage imageNamed:@"favsFilled"] forState:UIControlStateNormal];
	} else {
		[cell.favButton setImage:[UIImage imageNamed:@"favsEmpty"] forState:UIControlStateNormal];
	}
	
	[cell.favButton addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
	[cell.infoButton addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
	[cell.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView beginUpdates];
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
		self.selectedIndexPath = nil;
	} else {
		self.selectedIndexPath = indexPath;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView endUpdates];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
		return 240.f;
	return 60.f;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.tableView.isDragging) {
		[tableView beginUpdates];
		[tableView reloadData];
		[tableView endUpdates];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// Animate.
	if (!shouldAnimate) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			shouldAnimate = YES;
		});
		return;
	}
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
		EventsTableViewCell *xell = (EventsTableViewCell *)cell;
		NSArray <UIView *> *views = @[xell.locationImage, xell.locationLabel, xell.dateimage, xell.dateLabel, xell.maxPplImage, xell.maxPplLabel, xell.personImage, xell.personOfContactLabel];
		for (NSInteger i = 0; i < views.count; ++i) {
			UIView *view = views[i];
			view.transform = CGAffineTransformMakeTranslation((12 + (i/2) * 2) * ((i % 2 == 0) ? -1 : 1), 0);
			view.alpha = 0.0;
			[UIView animateWithDuration:0.6 delay:(i/2) * 0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
				view.transform = CGAffineTransformIdentity;
				view.alpha = 1.0;
			} completion:nil];
		}
	}
}

#pragma mark - Cell actions

- (void)favAction:(id)sender {
	shouldAnimate = NO;
	NSInteger row = [sender tag];
//	NSLog(@"Fav clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	event.isFavorite = !event.isFavorite;
	NSError *error;
	[self.context save:&error];
	[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)infoAction:(id)sender {
	NSInteger row = [sender tag];
//	NSLog(@"Info clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", event.eventName] message:[NSString stringWithFormat:@"%@", event.eventDesc] preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)callAction:(id)sender {
	NSInteger row = [sender tag];
//	NSLog(@"Call clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
//	NSLog(@"%@", event.contactNumber);
	NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [event.contactNumber stringByReplacingOccurrencesOfString:@" " withString:@""]]];
	[[UIApplication sharedApplication] openURL:callURL];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
