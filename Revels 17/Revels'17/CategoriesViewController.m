//
//  CategoriesViewController.m
//  Revels'16
//
//  Created by Abhishek Vora on 15/12/16.
//  Copyright © 2016 Abhishek Vora. All rights reserved.
//

#import "CategoriesViewController.h"
#import "FavouritesTableViewController.h"
#import "CategoriesTableViewCell.h"
#import "CategoriesPageViewController.h"
#import "CategoriesCollectionViewCell.h"
#import "CategoriesJSONModel.h"

@interface CategoriesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate>

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchRequest *fetchRequest;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CategoriesViewController {
    NSMutableArray *catArray;
    Reachability *reachability;
	BOOL animateCells;
}

-(void) loadCategoriesFromApi
{
//    SVHUD_SHOW;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            
            NSURL *custumUrl = [[NSURL alloc]initWithString:@"http://api.mitportals.in/categories/"];
            NSData *mydata = [NSData dataWithContentsOfURL:custumUrl];
            NSError *error;
            
            if (mydata!=nil)
            {
                id jsonData = [NSJSONSerialization JSONObjectWithData:mydata options:kNilOptions error:&error];
                id array = [jsonData valueForKey:@"data"];
				
				catArray = [[CoreDataHelper getCategoriesFromJSONData:array storeIntoManagedObjectContext:self.context] mutableCopy];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						SVHUD_HIDE;
						NSError *err;
//						animateCells = YES;
						[self.context save:&err];
						[self.collectionView reloadData];
					});
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
		animateCells = NO;
	} else {
		animateCells = YES;
	}
	
//    if(reachability.isReachable) not working
        [self loadCategoriesFromApi]; //json is parsed but values aren't getting stored in categoryList
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"catCell"];
	
	self.collectionView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
	
	UIImageView *headerImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	headerImageView1.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView1.frame = CGRectMake(0, -140, self.view.bounds.size.width, 120);
	headerImageView1.alpha = 0.5;
	[self.collectionView addSubview:headerImageView1];
	
	[self setNeedsStatusBarAppearanceUpdate];
	
	if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
		[self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
	}
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (self.pushFavs) {
		[self favsAction:nil];
		self.pushFavs = NO;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)favsAction:(id)sender {
	FavouritesTableViewController *ftvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesVC"];
	ftvc.hidesBottomBarWhenPushed = YES;
	ftvc.navigationItem.leftBarButtonItem = nil;
	[self.navigationController pushViewController:ftvc animated:YES];
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
    NSLog("%@",category.catName);
	return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger index = indexPath.row;
	if (animateCells) {
		cell.alpha = 0;
		cell.transform = CGAffineTransformMakeScale(0.7, 0.7);
		[UIView animateWithDuration:0.3 delay:index * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
			cell.alpha = 1.0;
			cell.transform = CGAffineTransformIdentity;
		} completion:^(BOOL finished) {
			if (index >= 11) {
				animateCells = NO;
			}
		}];
	}
}

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

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - UIViewController previewing delegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
	UICollectionViewLayoutAttributes *cellattrs = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
	[previewingContext setSourceRect:cellattrs.frame];
	CategoriesPageViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesPageVC"];
	CategoryStore *cat = [catArray objectAtIndex:indexPath.row];
	dest.category = cat;
	return dest;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
	[self.navigationController pushViewController:viewControllerToCommit animated:YES];
}


@end
