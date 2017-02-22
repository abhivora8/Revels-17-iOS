//
//  CategoriesViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesTableViewCell.h"
#import "CategoriesPageViewController.h"
#import "CategoriesJSONModel.h"

@interface CategoriesViewController () 

@end

@implementation CategoriesViewController
{
    NSMutableArray *categoryList;
    NSMutableArray *catArray;
    IBOutlet UITableView *catTableView;
    Reachability *reachability;
}

-(void) loadCategoriesFromApi
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            
            NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/categories/"];
            NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
            NSError *error;
            
            if (mydata!=nil)
            {
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
                catArray = [CategoriesJSONModel getArrayFromJson:array];
				
				categoryList = [NSMutableArray new];
                for(CategoriesJSONModel *p in catArray)
                {
                    [categoryList addObject:p.catName];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [catTableView reloadData];
                });
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
//            NSLog(@"%@", catArray);
//            NSLog(@"%@", categoryList);
        }
    });
}
 

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if(reachability.isReachable) not working
        [self loadCategoriesFromApi]; //json is parsed but values aren't getting stored in categoryList
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return catArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesJSONModel *cat = [catArray objectAtIndex:indexPath.row];
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CategoriesTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoriesCell"];
		cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
    }
    cell.catName.text = cat.catName;
	cell.catImage.image = [UIImage imageNamed:cat.catName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 4.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 4.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"catToEvents" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"catToEvents"]) {
        NSIndexPath *indexPath = [catTableView indexPathForSelectedRow];
        CategoriesPageViewController *dest = segue.destinationViewController;
        CategoriesJSONModel *cat = [catArray objectAtIndex:indexPath.row];
        dest.catName = cat.catName;
        dest.catId = cat.catId;
        dest.title = cat.catName;
    }
}


@end
