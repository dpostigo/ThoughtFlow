//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MoodboardController.h"
#import "TFMoodboardCollectionViewCell.h"
#import "UIColor+TFApp.h"

@implementation MoodboardController

- (void) viewDidLoad {
    [super viewDidLoad];

    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;

    CGFloat cellHeight = _collection.height / 3;
    NSLog(@"cellHeight = %f", cellHeight);
    UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *) _collection.collectionViewLayout;
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
    return 3 * 20;
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewCell *ret = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
            forIndexPath: indexPath];

    if ([ret isKindOfClass: [TFMoodboardCollectionViewCell class]]) {

        TFMoodboardCollectionViewCell *cell = (TFMoodboardCollectionViewCell *) ret;
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;

        cell.infoButton.tag = indexPath.item;
        //        Project *project = [self projectForIndexPath: indexPath];
        //        if (project) {
        //            cell.project = project;
        //        }
        //        cell.button.tag = indexPath.item;
        //        [cell.button addTarget: self action: @selector(handleTrashButton:)
        //              forControlEvents: UIControlEventTouchUpInside];
    }

    return ret;
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


@end