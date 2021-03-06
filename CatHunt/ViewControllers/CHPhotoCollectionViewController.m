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
#import <AssetsLibrary/AssetsLibrary.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>

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
    if (self.dataSource.isLoading) {
        return;
    }
    
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

- (void)loadMore
{
    if (self.dataSource.isLoading) {
        return;
    }
    
    NSInteger numberOfItemsBeforeUpdates = [self.collectionView numberOfItemsInSection:0];
    
    [self.dataSource loadNextWithSuccess:^{
        [self.collectionView performBatchUpdates:^{
            NSInteger numberOfItemsAfterLoaded = self.dataSource.count;
            
            if (numberOfItemsAfterLoaded < numberOfItemsBeforeUpdates) {
                return;
            }
            
            NSMutableArray *indexPathsForInsert = [NSMutableArray array];
            for (NSInteger i=numberOfItemsBeforeUpdates; i<numberOfItemsAfterLoaded; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [indexPathsForInsert addObject:indexPath];
            }
            
            [self.collectionView insertItemsAtIndexPaths:indexPathsForInsert];
        } completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"load more error:%@", error);
    }];
}

- (void)saveImage:(UIImage *)image
{
    ALAssetsLibrary *assertLibrary = [[ALAssetsLibrary alloc] init];
    [assertLibrary writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"image save error:%@", error);
            return;
        }
        
        [JDStatusBarNotification showWithStatus:@"画像を保存しました" dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = nil;
    
    CHTweetModel *tweet = [self.dataSource tweetAtIndex:indexPath.row];
    
    if (tweet) {
        [cell.imageView sd_setImageWithURL:tweet.imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                NSLog(@"image loading error:%@", error);
            }
        }];
    }
    
    if (indexPath.row == self.dataSource.count - 1) {
        [self loadMore];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPhotoCollectionViewCell *cell = (CHPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = cell.imageView.image;
    
    [self saveImage:image];
}

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
