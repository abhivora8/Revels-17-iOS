//
//  ResultsViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsTableViewCell.h"

@interface ResultsViewController ()
{
    NSArray *resultsArray;
}

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    resultsArray = [[NSArray alloc] initWithObjects:@"Eve1",@"Eve2",@"Eve3", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
    
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ResultsTableViewCell" bundle:nil] forCellReuseIdentifier:@"resultsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell"];
        
    }
    cell.eventName.text = [resultsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
