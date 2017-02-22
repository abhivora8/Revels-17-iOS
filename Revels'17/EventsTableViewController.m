//
//  EventsTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 26/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsTableViewController.h"
#import "FilteredEventsTableViewCell.h"
#import "EventsDetailsJSONModel.h"

@interface EventsTableViewController ()

@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return self.eventList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilteredEventsTableViewCell *cell;
    
     if ([indexPath compare:self.selectedIndexPath] == NSOrderedSame) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"filteredEventsCellExp" forIndexPath:indexPath];
     } else {
         cell = [tableView dequeueReusableCellWithIdentifier:@"filteredEventsCell" forIndexPath:indexPath];
     }
    
    EventsDetailsJSONModel *model = [self.eventDetails objectAtIndex:indexPath.row];
    
    if ([model.cntctno isEqualToString:@" "])
        cell.contactLabel.text = @"Contact Info Unavailable";
    else
        cell.contactLabel.text = model.cntctno;
    cell.eveName.text = [self.eventList objectAtIndex:indexPath.row];
    cell.catName.text = self.catName;
    cell.maxPplLabel.text = model.eventMaxTeamSize;
    
    if([model.day isEqualToString:@"1"])
        cell.dateLabel.text = [NSString stringWithFormat:@"8-03-17"];
    else if([model.day isEqualToString:@"2"])
        cell.dateLabel.text = [NSString stringWithFormat:@"9-03-17"];
    else if([model.day isEqualToString:@"3"])
        cell.dateLabel.text = [NSString stringWithFormat:@"10-03-17"];
    else if([model.day isEqualToString:@"4"])
        cell.dateLabel.text = [NSString stringWithFormat:@"11-03-17"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        return 250.f;
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.isDragging) {
        [tableView beginUpdates];
        [tableView reloadData];
        [tableView endUpdates];
    }
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
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
