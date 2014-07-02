//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MoodboardController.h"
#import "TFMoodboardCollectionViewCell.h"
#import "TFPhoto.h"
#import "UIImageView+AFNetworking.h"



@implementation MoodboardController

- (void) viewDidLoad {
    [super viewDidLoad];

    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;

    CGFloat cellHeight = self.view.height / 3;
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) _collection.collectionViewLayout;
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(cellHeight, cellHeight);

    [_collection reloadData];
}


#pragma mark IBActions

- (IBAction) handleInfoButton: (UIButton *) button {
    NSUInteger index = (NSUInteger) button.tag;
    [self performSegueWithIdentifier: @"PinInfoSegue" sender: nil];

}

#pragma mark UICollectionViewDataSource

- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [self.images count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFMoodboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
            forIndexPath: indexPath];

    //    cell.layer.borderWidth = 0.5;
    //    cell.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;

    cell.infoButton.tag = indexPath.item;

    TFPhoto *photo = [self.images objectAtIndex: indexPath.item];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imageView setImageWithURL: photo.URL];

    //        Project *project = [self projectForIndexPath: indexPath];
    //        if (project) {
    //            cell.project = project;
    //        }
    //        cell.button.tag = indexPath.item;
    //        [cell.button addTarget: self action: @selector(handleTrashButton:)
    //              forControlEvents: UIControlEventTouchUpInside];

    return cell;
}


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    NSArray *indexPaths = collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *indexPath1 in indexPaths) {

        if (![indexPath1 isEqual: indexPath]) {
            [collectionView deselectItemAtIndexPath: indexPath1 animated: YES];
        }
    }
}

- (void) collectionView: (UICollectionView *) collectionView didDeselectItemAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (BOOL) collectionView: (UICollectionView *) collectionView shouldHighlightItemAtIndexPath: (NSIndexPath *) indexPath {
    return YES;
}

- (BOOL) collectionView: (UICollectionView *) collectionView shouldSelectItemAtIndexPath: (NSIndexPath *) indexPath {
    return YES;
}


- (BOOL) collectionView: (UICollectionView *) collectionView shouldDeselectItemAtIndexPath: (NSIndexPath *) indexPath {
    return YES;
}



#pragma mark Flow layout


- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger) section {
    return 0;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger) section {
    return 0;
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    CGFloat cellHeight = self.view.height / 3;
    //UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) _collection.collectionViewLayout;
    //flow.minimumLineSpacing = 0;
    //flow.minimumInteritemSpacing = 0;
    //flow.itemSize = ;
    return CGSizeMake(cellHeight, cellHeight);
}

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    return UIEdgeInsetsMake(-22, 0, 0, 0);
}


#pragma mark Getters

- (NSArray *) images {
    if (_images == nil) {
        _images = [NSArray array];
    }
    return _images;
}


@end