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

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *fetchRequest;

@end

@implementation CategoriesViewController
{
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
			
			SVHUD_HIDE;
            
            if (mydata!=nil)
            {
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
				
				catArray = [[CoreDataHelper getCategoriesFromJSONData:array storeIntoManagedObjectContext:self.context] mutableCopy];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					NSError *err;
					[self.context save:&err];
					[catTableView reloadData];
				});
			
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {

        }
    });
}
 

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.context = [AppDelegate sharedManagedObjectContext];
	self.fetchRequest = [CategoryStore fetchRequest];
	[self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES]]];
	
	catArray = [NSMutableArray new];
	
	// Load from store...
	NSError *error;
	catArray = [[self.context executeFetchRequest:self.fetchRequest error:&error] mutableCopy];
	
	if (catArray.count == 0) {
		SVHUD_SHOW;
	}
	
//    if(reachability.isReachable) not working
        [self loadCategoriesFromApi]; //json is parsed but values aren't getting stored in categoryList
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
    
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
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CategoriesTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoriesCell"];
		cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesCell"];
    }
	CategoryStore *category = [catArray objectAtIndex:indexPath.row];
	cell.catName.text = category.catName;
    cell.catImage.image = [UIImage imageNamed:category.catName];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"catToEvents"]) {
        NSIndexPath *indexPath = [catTableView indexPathForSelectedRow];
        CategoriesPageViewController *dest = segue.destinationViewController;
        CategoryStore *cat = [catArray objectAtIndex:indexPath.row];
        dest.catName = cat.catName;
        dest.catId = cat.catID;
        dest.title = cat.catName;
    }
}


@end
