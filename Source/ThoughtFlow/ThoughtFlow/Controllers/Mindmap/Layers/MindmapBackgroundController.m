//
// Created by Dani Postigo on 5/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MindmapBackgroundController.h"
#import "DPCollectionViewCell.h"
#import "UICollectionView+DPKit.h"
#import "TFPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "APIModel.h"
#import "Model.h"

@implementation MindmapBackgroundController

@synthesize images;
@synthesize imageString;

- (void) viewDidLoad {
    [super viewDidLoad];

    preloader = [[UIImageView alloc] init];

    _collection.pagingEnabled = YES;
    _collection.showsHorizontalScrollIndicator = NO;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.dataSource = self;
    _collection.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;

    //    self.view.backgroundColor = [UIColor tfBackgroundColor];
    _collection.backgroundColor = self.view.backgroundColor;

    //    self.view.backgroundColor = [UIColor redColor];
    //    [self.view addDebugBorder: [UIColor redColor]];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    _collection.frame = self.view.bounds;

    [self.view setNeedsUpdateConstraints];
    //    [self.view layoutIfNeeded];


    //    UICollectionViewFlowLayout *layout = _collection.flowLayoutCopy;
    //    layout.minimumLineSpacing = 0;
    //    layout.minimumInteritemSpacing = 0;
    //    layout.itemSize = CGSizeMake(self.view.width, self.view.height - layout.sectionInset.top - layout.sectionInset.bottom);
    //    [_collection setCollectionViewLayout: layout animated: NO];
    //    [_collection.collectionViewLayout invalidateLayout];
    //    [self fixCollectionView];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    NSLog(@"self.view.frame = %@", NSStringFromCGRect(self.view.frame));
    NSLog(@"_collection.frame = %@", NSStringFromCGRect(_collection.frame));

    //    [self fixCollectionView: YES];

}


#pragma mark Constraints

//- (void) updateViewConstraints {
//    [super updateViewConstraints];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSLog(@"self.view.constraints = %@", self.view.constraints);
//
//}


- (void) fixCollectionView: (BOOL) animated {

    //    NSLog(@"self.collection.height = %f", self.collection.height);
    UICollectionViewFlowLayout *layout = _collection.flowLayoutCopy;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height - layout.sectionInset.top - layout.sectionInset.bottom);
    [_collection setCollectionViewLayout: layout animated: animated];
    //    [layout invalidateLayout];

}



#pragma mark Setters

- (void) setImageString: (NSString *) imageString1 {
    if (imageString != imageString1) {
        imageString = [imageString1 mutableCopy];

        [UIView animateWithDuration: 0.4 animations: ^{
            _collection.alpha = 0;
        } completion: ^(BOOL finished) {

        }];

        [_apiModel getImages: imageString success: ^(NSArray *imageArray) {
            images = imageArray;
            [_collection reloadData];
            [_collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: NO];

            _model.selectedPhoto = images[0];
            [UIView animateWithDuration: 0.4 animations: ^{
                _collection.alpha = 1;
            }];

        } failure: nil];

    }

}

#pragma mark UICollectionViewDataSource

- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [self.images count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    DPCollectionViewCell *ret = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell" forIndexPath: indexPath];


    TFPhoto *photo = [self.images objectAtIndex: indexPath.item];
    ret.backgroundColor = self.view.backgroundColor;
    ret.imageView.alpha = 0.2;
    [ret.imageView setImageWithURL: photo.URL];
    ret.imageView.contentMode = UIViewContentModeScaleAspectFill;

    NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL: photo.URL];
    [ret.imageView setImageWithURLRequest: imageRequest placeholderImage: nil
            success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                ret.imageView.alpha = 0;
                ret.imageView.image = image;

                [UIView animateWithDuration: 0.4 animations: ^{
                    ret.imageView.alpha = 0.2;
                }];
            }
            failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

            }];

    [ret.imageView rasterize];
    [ret rasterize];

    [self preloadForIndexPath: indexPath];

    //    UIImage *image = [self.images objectAtIndex: indexPath.item];
    //    ret.backgroundColor = self.view.backgroundColor;
    //    ret.imageView.image = image;
    //    ret.imageView.alpha = 0.2;
    //
    //    [ret.imageView rasterize];
    //    [ret rasterize];

    //    [ret addDebugBorder: [UIColor yellowColor]];
    return ret;
}


- (void) preloadForIndexPath: (NSIndexPath *) indexPath {
    if (indexPath.item < [self.images count] - 1) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem: indexPath.item + 1 inSection: indexPath.section];
        TFPhoto *photo = [self.images objectAtIndex: nextIndexPath.item];
        [preloader setImageWithURL: photo.URL];
    }

}

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {
    NSIndexPath *indexPath = [_collection indexPathForItemAtPoint: _collection.contentOffset];

    if (indexPath.item < [self.images count] - 1) {

        //        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem: indexPath.item + 1 inSection: indexPath.section];
        TFPhoto *photo = [self.images objectAtIndex: indexPath.item];
        _model.selectedPhoto = photo;
        //        [preloader setImageWithURL: photo.URL];
    }
}

//
//
//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout referenceSizeForHeaderInSection: (NSInteger) section {
//    //-55 is a tweak value to remove top spacing
//    return CGSizeMake(0, -55);
//}


//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
//    return collectionView.frame.size;
//}
//
//- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
//    return UIEdgeInsetsMake(-5, 0, 0, 0);
//}
- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    return UIEdgeInsetsMake(-22, 0, 0, 0);
    //    return UIEdgeInsetsMake(collectionView.top, 0, 0, 0);
    //    return UIEdgeInsetsMake(-55, 10, 10, 10);
}


- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return self.view.bounds.size;
}
//- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger) section {
//    return 0;
//}
//
//- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger) section {
//    return 0;
//}


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




#pragma mark Getters

- (NSArray *) images {
    if (images == nil) {
        images = [NSArray array];
    }
    return images;
}

@end