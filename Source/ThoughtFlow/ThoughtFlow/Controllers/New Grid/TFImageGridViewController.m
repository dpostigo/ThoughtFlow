//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFImageGridViewController.h"
#import "TFMoodboardCollectionViewCell.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "TFImageGridViewCell.h"


@implementation TFImageGridViewController

- (id) init {
    TFImageGridViewController *ret = [[UIStoryboard storyboardWithName: @"Moodboard" bundle: nil] instantiateViewControllerWithIdentifier: @"TFImageGridViewController"];
    ret.images = [NSArray array];
    return ret;
}


- (void) viewDidLoad {
    [super viewDidLoad];
    [self _setupView];
    [self _setupCollection];
}



#pragma mark - Reload

- (void) setImages: (NSArray *) images {
    _images = images;
    [_collection reloadData];
}


- (void) setSelectedImage: (TFPhoto *) selectedImage {

    if ([_images containsObject: selectedImage]) {

        _selectedImage = selectedImage;
        NSUInteger index = [_images indexOfObject: selectedImage];
        [_collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: index inSection: 0] atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated: YES];
    }

}



#pragma mark - Setup

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

- (void) _setupCollection {
    CGFloat cellHeight = self.view.height / 3;

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(cellHeight, cellHeight);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collection = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout: flow];
    [self.view addSubview: _collection];

    _collection.translatesAutoresizingMaskIntoConstraints = NO;
    _collection.pagingEnabled = YES;
    _collection.backgroundColor = [UIColor clearColor];

    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _collection attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _collection attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _collection attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.topLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _collection attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0]
    ]];

    [_collection registerClass: [TFImageGridViewCell class] forCellWithReuseIdentifier: @"CollectionCell"];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.allowsMultipleSelection = YES;

    [_collection reloadData];

}


#pragma mark - UICollectionView

- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [self.images count];
}


- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFImageGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionCell" forIndexPath: indexPath];

    //    cell.layer.borderWidth = 0.5;
    //    cell.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;

    cell.infoButton.tag = indexPath.item;

    TFPhoto *photo = [self.images objectAtIndex: indexPath.item];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.imageView setImageWithURL: photo.URL];

    [self _notifyDequeuedCell: cell atIndexPath: indexPath];

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
    TFPhoto *image = [self.images objectAtIndex: indexPath.item];

    if (_delegate && [_delegate respondsToSelector: @selector(imageGridViewController:didSelectImage:atIndexPath:)]) {
        [_delegate imageGridViewController: self didSelectImage: image atIndexPath: indexPath];
    }
}


- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {
    NSIndexPath *indexPath = [_collection indexPathForItemAtPoint: _collection.contentOffset];
    TFPhoto *image = [self.images objectAtIndex: indexPath.item];
    _selectedImage = image;

    [self _notifyDidScrollToImage: image];

}



#pragma mark - Buttons

- (void) addTargetToButton: (UIButton *) button {
    [button addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];
}

- (IBAction) handleButton: (UIButton *) button {
    NSIndexPath *indexPath = [_collection indexPathForItemAtPoint: [_collection convertPoint: button.center fromView: button.superview]];
    TFImageGridViewCell *cell = (TFImageGridViewCell *) [_collection cellForItemAtIndexPath: indexPath];
    [self _notifyDidClickButton: button inCell: cell atIndexPath: indexPath];

}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger) section {

    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView: collectionView layout: collectionViewLayout minimumLineSpacingForSectionAtIndex: section];
    }
    return 0;
}

- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger) section {
    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [_delegate collectionView: collectionView layout: collectionViewLayout minimumInteritemSpacingForSectionAtIndex: section];
    }
    return 0;
}

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [_delegate collectionView: collectionView layout: collectionViewLayout sizeForItemAtIndexPath: indexPath];
    }
    CGFloat cellHeight = self.view.height / 3;
    return CGSizeMake(cellHeight, cellHeight);
}

- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [_delegate collectionView: collectionView layout: collectionViewLayout insetForSectionAtIndex: section];
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma mark - Notify

- (void) _notifyDequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    if (_delegate && [_delegate respondsToSelector: @selector(imageGridViewController:dequeuedCell:atIndexPath:)]) {
        [_delegate imageGridViewController: self dequeuedCell: cell atIndexPath: indexPath];
    }
}


- (void) _notifyDidClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    if (_delegate && [_delegate respondsToSelector: @selector(imageGridViewController:didClickButton:inCell:atIndexPath:)]) {
        [_delegate imageGridViewController: self didClickButton: button inCell: cell atIndexPath: indexPath];
    }
}


- (void) _notifyDidScrollToImage: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(imageGridViewController:didScrollToImage:)]) {
        [_delegate imageGridViewController: self didScrollToImage: image];
    }
}

@end