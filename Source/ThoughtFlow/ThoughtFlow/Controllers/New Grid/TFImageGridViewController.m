//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import "TFImageGridViewController.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"


@implementation TFImageGridViewController

- (instancetype) initWithImages: (NSArray *) images {
    self = [super init];
    if (self) {
        _images = images;

    }

    return self;
}


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _images = [NSArray array];
        [self _setupView];
        [self _setupCollection];
    }

    return self;
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.images = _images;

    //    if (_selectedImage) {
    //
    //        NSInteger index = [_images indexOfObject: _selectedImage];
    //        [_collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: index inSection: 0] atScrollPosition: UICollectionViewScrollPositionLeft animated: NO];
    //        //            [_collection.collectionViewLayout invalidateLayout];
    //    }
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if (_selectedImage) {
        //        [self scrollToImage: _selectedImage animated: YES];
        //        NSInteger index = [_images indexOfObject: _selectedImage];
        //        if (index != -1) {

        //            [_collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: index inSection: 0]
        //                    atScrollPosition: UICollectionViewScrollPositionNone
        //                    animated: NO];
        //            [_collection.collectionViewLayout invalidateLayout];
        //        }
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (_selectedImage) {

        [self scrollToImage: _selectedImage animated: YES];
    }
}






#pragma mark - Public


- (void) reload {
    [_collection reloadData];
}

- (void) reloadImage: (TFPhoto *) image {
    NSUInteger index = [self.images indexOfObject: image];
    [self reloadImageAtIndexPath: [NSIndexPath indexPathForItem: index inSection: 0]];
}

- (void) reloadImageAtIndexPath: (NSIndexPath *) indexPath {
    [_collection reloadItemsAtIndexPaths: @[indexPath]];
}

- (void) reloadVisibleItems {
    [_collection reloadItemsAtIndexPaths: [_collection indexPathsForVisibleItems]];

}

#pragma mark - Reload

- (void) setImages: (NSArray *) images {
    _images = images;
    if ([_images count] > 0) {
        _selectedImage = _images[0];
    }
    if (self.isViewLoaded) {
        [_collection reloadData];
    }
}


- (void) setSelectedImage: (TFPhoto *) selectedImage {
    _selectedImage = selectedImage;
}



#pragma mark - Scroll


- (void) scrollToImage: (TFPhoto *) image {
    [self scrollToImage: image animated: NO];
}


- (void) scrollToImage: (TFPhoto *) image animated: (BOOL) flag {

    if (_images) {

        NSUInteger index = [self.images indexOfObject: image];

        if (index != -1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem: index inSection: 0];
            @try {

                [_collection scrollToItemAtIndexPath: indexPath atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
                [self _notifyDidScrollToImage: image];

            }
            @catch (NSException *exception) {

            }

        }
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
    _collection.backgroundColor = [UIColor clearColor];
    _collection.opaque = NO;

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

    //    [_collection reloadData];

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
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;

    TFPhoto *photo = [self.images objectAtIndex: indexPath.item];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    BOOL oldCaching = NO;

    if (oldCaching) {
        [cell.imageView setImageWithURL: photo.URL];

    } else {
        NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL: photo.URL];
        UIImage *cachedImage = [[[UIImageView class] sharedImageCache] cachedImageForRequest: imageRequest];

        if (cachedImage) {
            cell.imageView.image = cachedImage;
            [cell rasterize];

        } else {

            cell.alpha = 0;
            __weak TFImageGridViewCell *weakCell = cell;
            [cell.imageView setImageWithURLRequest: imageRequest
                    placeholderImage: nil
                    success: ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                        __strong TFImageGridViewCell *strongCell = weakCell;
                        if (strongCell) {
                            strongCell.imageView.image = image;
                            [UIView animateWithDuration: 0.4 animations: ^{
                                strongCell.alpha = 1;
                            }];
                        }

                    }
                    failure: nil];
        }

    }

    [self _notifyDequeuedCell: cell atIndexPath: indexPath];

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
    return UIEdgeInsetsMake(-22, 0, 0, 0);
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