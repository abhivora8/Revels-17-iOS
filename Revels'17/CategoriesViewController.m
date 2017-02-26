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
#import "CategoriesCollectionViewCell.h"
#import "CategoriesJSONModel.h"

@interface CategoriesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *fetchRequest;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoriesViewController
{
    NSMutableArray *catArray;
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
					[self.collectionView reloadData];
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
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"catCell"];
	
	self.collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection view data souce

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return catArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CategoriesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
	CategoryStore *category = [catArray objectAtIndex:indexPath.row];
	cell.catNameLabel.text = category.catName;
	cell.catImageView.image = [UIImage imageNamed:category.catName];
	return cell;
}

#pragma mark - Collection view delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat w = (self.view.bounds.size.width)/3.f - 8;
	return CGSizeMake(w, w * 144 / 120.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CategoriesPageViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesPageVC"];
	CategoryStore *cat = [catArray objectAtIndex:indexPath.row];
	dest.category = cat;
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	[self.navigationController pushViewController:dest animated:YES];
}

@end
