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

@end

@implementation EventsByDayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
	[self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell2" bundle:nil] forCellReuseIdentifier:@"cellExp"];
	
	self.selectedIndexPath = nil;
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	EventsTableViewCell *cell;
    EventsDetailsJSONModel *demoModel = [self.events objectAtIndex:indexPath.row];
 
	if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"cellExp" forIndexPath:indexPath];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	}
	
    cell.catName.text = demoModel.categoryEventName;
    cell.eveName.text = demoModel.eventName;
    cell.maxPplLabel.text = demoModel.eventMaxTeamSize;
    cell.day = demoModel.day;
	
    // Configure the cell...
    
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
