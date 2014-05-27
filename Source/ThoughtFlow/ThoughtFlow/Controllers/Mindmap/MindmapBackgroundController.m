//
// Created by Dani Postigo on 5/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "MindmapBackgroundController.h"
#import "TFImageFetchOperation.h"
#import "DPCollectionViewCell.h"
#import "UICollectionView+DPKit.h"
#import "UIColor+TFApp.h"

@implementation MindmapBackgroundController

@synthesize images;

- (void) viewDidLoad {
    [super viewDidLoad];

    [_queue addOperation: [[TFImageFetchOperation alloc] initWithImageSuccess: ^(NSArray *imageArray) {
        images = imageArray;
        _imageView.image = images[0];
        [_collection reloadData];
    }]];

    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.dataSource = self;
    _collection.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;

    //    self.view.backgroundColor = [UIColor tfBackgroundColor];
    _collection.backgroundColor = self.view.backgroundColor;

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    [self.view layoutIfNeeded];

    NSLog(@"_collection.frame = %@", NSStringFromCGRect(_collection.frame));
    NSLog(@"self.view.frame = %@", NSStringFromCGRect(self.view.frame));

    UICollectionViewFlowLayout *layout = _collection.flowLayoutCopy;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height - layout.sectionInset.top - layout.sectionInset.bottom);
    [_collection setCollectionViewLayout: layout animated: NO];
    [_collection.collectionViewLayout invalidateLayout];
    //    [self fixCollectionView];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    NSLog(@"_collection.frame = %@", NSStringFromCGRect(_collection.frame));
    NSLog(@"self.view.frame = %@", NSStringFromCGRect(self.view.frame));

    [self fixCollectionView: YES];

}

- (void) fixCollectionView: (BOOL) animated {

    //    NSLog(@"self.collection.height = %f", self.collection.height);
    UICollectionViewFlowLayout *layout = _collection.flowLayoutCopy;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height - layout.sectionInset.top - layout.sectionInset.bottom);
    [_collection setCollectionViewLayout: layout animated: animated];
    //    [layout invalidateLayout];

}

#pragma mark UICollectionViewDataSource

- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [self.images count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    DPCollectionViewCell *ret = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell" forIndexPath: indexPath];

    UIImage *image = [self.images objectAtIndex: indexPath.item];
    ret.backgroundColor = self.view.backgroundColor;
    ret.imageView.image = image;
    ret.imageView.alpha = 0.2;
    [ret.imageView rasterize];
    [ret rasterize];
    return ret;
}


- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout referenceSizeForHeaderInSection: (NSInteger) section {
    //-55 is a tweak value to remove top spacing
    return CGSizeMake(0, -55);
}


//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
//    return collectionView.frame.size;
//}
//
//- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
//    return UIEdgeInsetsMake(-5, 0, 0, 0);
//}

- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger) section {
    return 0;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger) section {
    return 0;
}


- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation duration: (NSTimeInterval) duration {
    [self.collection.collectionViewLayout invalidateLayout];
}
//
//- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation {
//    // Force realignment of cell being displayed
//    CGSize currentSize = self.collection.bounds.size;
//    CGPoint currentOffset = [self.collection contentOffset];
//    int currentIndex = (int) (currentOffset.x / self.collection.frame.size.width);
//
//    float offset = currentIndex * currentSize.width;
//    [self.collection setContentOffset: CGPointMake(offset, 0)];
//}
//
//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return collectionView.frame.size;
//}


#pragma mark Getters

- (NSArray *) images {
    if (images == nil) {
        images = [NSArray array];
    }
    return images;
}

@end