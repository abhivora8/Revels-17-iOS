//
//  EventsTableViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 26/01/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsTableViewController.h"
#import "FilteredEventsTableViewCell.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController {
    NSArray *events;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     if([self.catName isEqualToString:@"Cat1"])
        events = [NSArray arrayWithObjects:@"Cat1 Eve 1",@"Cat1 Eve 2",@"Cat1 Eve 3",@"Cat1 Eve 4", nil];
     else if([self.catName isEqualToString:@"Cat2"])
        events = [NSArray arrayWithObjects:@"Cat2 Eve 1",@"Cat2 Eve 2",@"Cat2 Eve 3",@"Cat2 Eve 4", nil];
     else
         events = nil;
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
    return events.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilteredEventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filteredEventsCell"];
    if (cell == nil)
    {
        cell = [[FilteredEventsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filteredEventsCell"];
    }
    
    cell.eveName.text = [events objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
