//
//  CHPhotoCollectionViewController.m
//  CatHunt
//
//  Created by shoby on 2015/01/07.
//  Copyright (c) 2015年 shoby. All rights reserved.
//

#import "CHPhotoCollectionViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "CHSearchTweetsDataSource.h"
#import "CHTweetModel.h"
#import "CHEntitiesModel.h"
#import "CHMediaModel.h"
#import "CHSizesModel.h"
#import "CHSizesModel.h"
#import "CHPhotoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const NSInteger CHPhotoCollectionViewControllerColumnCount = 2.0;
static const NSInteger CHPhotoCollectionViewControllerItemSpace = 4.0;

@interface CHPhotoCollectionViewController ()<CHTCollectionViewDelegateWaterfallLayout>
@property (strong, nonatomic) CHSearchTweetsDataSource *dataSource;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, readonly) CGFloat itemWidth;
@end

@implementation CHPhotoCollectionViewController

static NSString * const reuseIdentifier = @"PhotoCollectionViewCell";

- (CGFloat)itemWidth
{
    NSInteger numberOfSpaces = CHPhotoCollectionViewControllerColumnCount + 1;
    NSInteger totalSpacesWidth = numberOfSpaces * CHPhotoCollectionViewControllerItemSpace;
    
    return (self.collectionView.bounds.size.width - totalSpacesWidth) / CHPhotoCollectionViewControllerColumnCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Cat Hunt";
    
    self.dataSource = [[CHSearchTweetsDataSource alloc] initWithQuery:@"#cat filter:images"];
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = CHPhotoCollectionViewControllerColumnCount;
    layout.minimumColumnSpacing = CHPhotoCollectionViewControllerItemSpace;
    layout.minimumInteritemSpacing = CHPhotoCollectionViewControllerItemSpace;
    layout.sectionInset = UIEdgeInsetsMake(CHPhotoCollectionViewControllerItemSpace,CHPhotoCollectionViewControllerItemSpace, CHPhotoCollectionViewControllerItemSpace, CHPhotoCollectionViewControllerItemSpace);
    
    self.collectionView.collectionViewLayout = layout;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
    [self reload];
}

- (void)reload
{
    [self.dataSource reloadWithSuccess:^{
        [self.collectionView reloadData];
        [self.collectionView.collectionViewLayout invalidateLayout];
        
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self.refreshControl endRefreshing];
    }];
}

- (void)refresControlValueChanged:(id)sender
{
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CHTweetModel *tweet = [self.dataSource tweetAtIndex:indexPath.row];
    
    if (tweet) {
        [cell.imageView sd_setImageWithURL:tweet.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"image loading error:%@", error);
            }
        }];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHTweetModel *tweet = [self.dataSource tweetAtIndex:indexPath.row];
    return [self itemSizeForTweet:tweet];
}

- (CGSize)itemSizeForTweet:(CHTweetModel *)tweet
{
    if (!tweet) {
        return CGSizeZero;
    }
    
    CGFloat itemWidth = self.itemWidth;
    CGFloat itemHeight = itemWidth / tweet.imageWidth * tweet.imageHeight;
    
    return CGSizeMake(itemWidth, itemHeight);
}

@end
