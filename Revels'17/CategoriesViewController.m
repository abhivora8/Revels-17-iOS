//
//  CategoriesViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesTableViewCell.h"
#import "EventsTableViewController.h"

@interface CategoriesViewController () 
{
    NSMutableArray *filteredEventList;
}

@end

@implementation CategoriesViewController
{
    NSArray *categoryList;
    IBOutlet UITableView *catTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    categoryList = [[NSArray alloc] initWithObjects: @"One",@"Two",@"Three",@"Four", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CategoriesTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoriesCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
        
    }
    cell.catName.text = [categoryList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"catToEvents"]) {
        NSIndexPath *indexPath = [catTableView indexPathForSelectedRow];
        EventsTableViewController *dest = segue.destinationViewController;
        dest.catName = [categoryList objectAtIndex:indexPath.row];
        dest.title = dest.catName;
    }
}


@end
