//
//  InstagramV2ViewController.m
//  Revels'17
//
//  Created by Abhishek Vora on 21/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "InstagramV2ViewController.h"
#import "ParallaxCollectionViewCell.h"
#import "InstagramData.h"
#import "InstagramDetailViewController.h"
#import "InstagramRootViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <KWTransition/KWTransition.h>

// Set your client ID here...
#define kClientID @"3d1dcff5e23c4c70b27ffd700628282d"

@interface InstagramV2ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) KWTransition *transition;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@end

@implementation InstagramV2ViewController {
    NSMutableArray *instagramObjects;
    NSURL *nextURL;
    NSIndexPath *lastIndexPath;
    
    NSString *kTagToSearch;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    kTagToSearch = @"techtatva17";
    
    self.searchBar.text = kTagToSearch;
    
    [self refreshAction:nil];
    
    self.transition = [KWTransition manager];
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
	headerImageView.contentMode = UIViewContentModeScaleAspectFit;
	headerImageView.frame = CGRectMake(0, -120, self.view.bounds.size.width, 80);
	headerImageView.alpha = 0.5;
	[self.collectionView addSubview:headerImageView];
	
	if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
		[self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
	}
    
}

- (void)viewWillAppear:(BOOL)animated {
	
//	self.collectionView.contentOffset = CGPointMake(0, -64);
    
}

- (IBAction)refreshAction:(id)sender {
    
    SVHUD_SHOW;
    
    instagramObjects = [NSMutableArray new];
    
    NSString *URLString = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/techtatva17/media/recent?access_token=630237785.f53975e.8dcfa635acf14fcbb99681c60519d04c"];
    
    nextURL = [NSURL URLWithString:URLString];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if ([reachability isReachable])
        [self fetchImages];
    else
        SVHUD_FAILURE(@"No connection!");
    
}

- (void)fetchImages {
    
    //	SVHUD_SHOW;
    
    ASMutableURLRequest *request = [ASMutableURLRequest getRequestWithURL:nextURL];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            SVHUD_FAILURE(@"Network Error!");
            return;
        }
        
        PRINT_RESPONSE_HEADERS_AND_CODE;
        
        @try {
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (statusCode == 200) {
                
                if ([jsonData valueForKeyPath:@"pagination.next_url"])
                    nextURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [jsonData valueForKeyPath:@"pagination.next_url"]]];
                
                id imagesJSON = [jsonData valueForKey:@"data"];
                NSArray *imagesArray = [InstagramData getArrayFromJSONData:imagesJSON];
                
                [instagramObjects addObjectsFromArray:imagesArray];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    //				[self.collectionView reloadInputViews];
                    SVHUD_HIDE;
                    lastIndexPath = [NSIndexPath indexPathForRow:instagramObjects.count - 9 inSection:0];
                });
                
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Insta fetch error: %@", exception.reason);
        }
        
    }] resume];
    
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return instagramObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ParallaxCollectionViewCell *cell = (ParallaxCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"instaCell" forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"instaCell" forIndexPath:indexPath];
    
    InstagramData *instaData = [instagramObjects objectAtIndex:indexPath.row];
    
    cell.imageURL = instaData.lowResURL;
    cell.placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    cell.tagsLabel.text = instaData.tags;
    cell.likesCountLabel.text = [NSString stringWithFormat:@"%li", instaData.likesCount];
    cell.commentsCountLabel.text = [NSString stringWithFormat:@"%li", instaData.commentsCount];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InstagramRootViewController *irvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramRootVC"];
    irvc.instagramObjects = instagramObjects;
    irvc.presentationIndex = indexPath.row;
    
    self.transition.style = KWTransitionStyleFadeBackOver;
    
    [irvc setTransitioningDelegate:self];
    
    [self.navigationController presentViewController:irvc animated:YES completion:nil];
}

#pragma mark - DZN Empty Data Set Source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"RevelsCircle"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return GLOBAL_BACK_COLOR;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"No images right now.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:18.f],
                                 NSForegroundColorAttributeName: GLOBAL_RED_COLOR};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Check your connection and try again.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:14.f],
                                 NSForegroundColorAttributeName: [UIColor ghostWhiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:22.f], NSForegroundColorAttributeName: GLOBAL_YELLOW_COLOR};
	
    return [[NSAttributedString alloc] initWithString:@"Reload" attributes:attributes];
}

#pragma mark - DZN Empty Data Set Source

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (instagramObjects.count == 0);
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    [self fetchImages];
}

#pragma mark - View controller animated transistioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    self.transition.action = KWTransitionStepPresent;
    return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.transition.action = KWTransitionStepDismiss;
    return self.transition;
}

#pragma mark - Collection view delegate flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = self.collectionView.bounds.size.width/2;
    return CGSizeMake(size, size);
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self refreshAction:nil];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSArray *visibleCells = self.collectionView.visibleCells;
        for (ParallaxCollectionViewCell *cell in visibleCells) {
            CGFloat yOffset = ((self.collectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
            cell.imageOffset = CGPointMake(0.0f, yOffset);
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:instagramObjects.count - 1 inSection:0];
        if ([self.collectionView.indexPathsForVisibleItems containsObject:lastIndexPath]) {
            lastIndexPath = nil;
            //			SVHUD_SHOW;
            [self fetchImages];
        }
        if ([self.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
            if (lastIndexPath == nil)
                SVHUD_SHOW;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
	UICollectionViewLayoutAttributes *cellattrs = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
	[previewingContext setSourceRect:cellattrs.frame];
	InstagramRootViewController *irvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InstagramRootVC"];
	irvc.instagramObjects = instagramObjects;
	irvc.presentationIndex = indexPath.row;
	irvc.peeking = YES;
	irvc.parentX = self;
	return irvc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
	[self.navigationController presentViewController:viewControllerToCommit animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
