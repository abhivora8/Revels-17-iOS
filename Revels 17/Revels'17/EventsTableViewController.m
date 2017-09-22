//
//  EventsTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 26/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "EventsTableViewController.h"
#import "FilteredEventsTableViewCell.h"
#import "EventsDetailsJSONModel.h"

@interface EventsTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSArray <EventStore *> *events;

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
	
//	[self.tableView registerNib:[UINib nibWithNibName:@"FilteredEventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"filteredEventsCell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"FilteredEventsTableViewCell2" bundle:nil] forCellReuseIdentifier:@"filteredEventsCellExp"];
	
	self.context = [AppDelegate sharedManagedObjectContext];
	
	NSError *error;
	self.events = [self.context executeFetchRequest:[EventStore fetchRequest] error:&error];
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.catName]];
	headerImageView.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView.frame = CGRectMake(0, -80, self.view.bounds.size.width - 20, 80);
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
    return self.schedules.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilteredEventsTableViewCell *cell;
    
//     if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"filteredEventsCellExp" forIndexPath:indexPath];
//     } else {
//         cell = [tableView dequeueReusableCellWithIdentifier:@"filteredEventsCell" forIndexPath:indexPath];
//     }
		 
//    EventsDetailsJSONModel *model = [self.eventDetails objectAtIndex:indexPath.row];
	
	ScheduleStore *schedule = [self.schedules objectAtIndex:indexPath.row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	
	cell.eveName.text = [NSString stringWithFormat:@"%@ %@", event.eventName, ([schedule.round isEqualToString:@"-"])?@"":[NSString stringWithFormat:@"(%@)", schedule.round]];
	cell.maxPplLabel.text = [NSString stringWithFormat:@"Max team size: %@", event.eventMaxTeamSize];
	
	cell.day = schedule.day;
	cell.locationLabel.text = schedule.venue;
	cell.contactLabel.text = event.contactName;
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

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
        self.selectedIndexPath = nil;
    } else {
        self.selectedIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endUpdates];
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame)
        return 216.f;
//    return 72.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 4.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 4.f;
}

/*
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.isDragging) {
        [tableView beginUpdates];
        [tableView reloadData];
        [tableView endUpdates];
    }
}
*/

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

//#pragma mark - DZN Empty Data Set Source
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:self.catName];
//}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
	return GLOBAL_BACK_COLOR;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	
	NSString *text = [NSString stringWithFormat:@"%@ has no events for this day.", self.catName];
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Neutraface2Display-Bold" size:24.f],
								 NSForegroundColorAttributeName: GLOBAL_RED_COLOR};
	
	return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
	return (self.schedules.count == 0);
}

#pragma mark - Cell actions

- (void)favAction:(id)sender {
	NSInteger row = [sender tag];
	//	NSLog(@"Fav clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	event.isFavorite = !event.isFavorite;
	NSError *error;
	[self.context save:&error];
//	[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView reloadData];
}

- (void)infoAction:(id)sender {
	NSInteger row = [sender tag];
	//	NSLog(@"Info clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
    
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
	//	NSLog(@"Call clicked at %li", row);
	ScheduleStore *schedule = [self.schedules objectAtIndex:row];
	EventStore *event = [[self.events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", schedule.catID, schedule.eventID]] firstObject];
	//	NSLog(@"%@", event.contactNumber);
	NSURL *callURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [event.contactNumber stringByReplacingOccurrencesOfString:@" " withString:@""]]];
	[[UIApplication sharedApplication] openURL:callURL];
}

-(void) dismissViewController{
    
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
