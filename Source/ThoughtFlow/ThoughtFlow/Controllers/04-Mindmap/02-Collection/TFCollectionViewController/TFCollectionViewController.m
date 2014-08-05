//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import <BlocksKit/NSObject+BKAssociatedObjects.h>
#import <AHEasing/easing.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFCollectionViewController.h"
#import "TFCollectionViewCell.h"
#import "TFPhoto.h"
#import "TFCollectionViewFullLayout.h"
#import "UICollectionView+DPKit.h"
#import "TFFullLayout.h"
#import "TFCollectionViewGridLayout.h"
#import "TFCollectionTransitionLayout.h"
#import "NSObject+Delay.h"
#import "JKInterpolationMath.h"
#import "TFMindmapLayout.h"
#import "TFImageGridViewCell.h"
#import "TFDynamicMindmapGridLayout.h"
#import "TFMindmapGridLayout.h"


#define NEW_CELL 0

@implementation TFCollectionViewController

NSString *const TFCollectionViewAnimationDataKey = @"TFCollectionViewAnimationDataKey";
NSString *const TFCollectionViewAnimationDurationKey = @"TFCollectionViewAnimationDurationKey";
NSString *const TFCollectionViewAnimationEasingKey = @"TFCollectionViewAnimationEasingKey";
NSString *const TFCollectionViewAnimationStartTimeKey = @"TFCollectionViewAnimationStartTimeKey";
NSString *const TFCollectionViewAnimationLinkKey = @"TFCollectionViewAnimationLinkKey";
NSString *const TFCollectionViewCellIdentifier = @"TFCollectionViewCellIdentifier";


- (id) init {
    //        TFCollectionViewGridLayout *layout = [[TFCollectionViewGridLayout alloc] init];
    //    TFMindmapLayout *layout = [[TFMindmapLayout alloc] init];
    //    TFMindmapLayout *layout = [[TFMindmapLayout alloc] init];

    //    TFMindmapLayout *layout = [[TFMindmapLayout alloc] init];
    TFMindmapGridLayout *layout = [[TFMindmapGridLayout alloc] init];
    //    layout.numberOfRows = 3;


    //    layout.isFullscreen = YES;
    return [self initWithCollectionViewLayout: layout];
}

- (id) initWithCollectionViewLayout: (UICollectionViewLayout *) layout {
    self = [super initWithCollectionViewLayout: layout];
    if (self) {
        _images = [NSArray array];

        if ([layout isKindOfClass: [TFCollectionViewGridLayout class]]) {
            _gridLayout = (TFCollectionViewGridLayout *) layout;
            _fullLayout = [[TFCollectionViewFullLayout alloc] init];
        } else if ([layout isKindOfClass: [TFCollectionViewFullLayout class]]) {
            _gridLayout = [[TFCollectionViewGridLayout alloc] init];
            _fullLayout = (TFCollectionViewFullLayout *) layout;
            _isFullscreen = YES;
        }

        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.collectionView.pagingEnabled = NO;
        self.collectionView.directionalLockEnabled = YES;

        [self.collectionView registerClass: [TFImageGridViewCell class] forCellWithReuseIdentifier: TFCollectionViewCellIdentifier];

        //        [self.collectionView registerClass: [TFCollectionViewCell class] forCellWithReuseIdentifier: TFCollectionViewCellIdentifier];
    }

    return self;
}


#pragma mark - Public

- (void) setImages: (NSArray *) images {
    _images = images;
    [self.collectionView reloadData];
}


#pragma mark - Public: Transition

- (void) transitionToLayout: (UICollectionViewLayout *) layout duration: (CGFloat) duration completion: (void (^)(BOOL completed, BOOL finished)) completion {
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget: self selector: @selector(updateTransitionProgress:)];

    NSDictionary *data = @{
            TFCollectionViewAnimationDurationKey : @(duration),
            TFCollectionViewAnimationStartTimeKey : @(CACurrentMediaTime()),
            TFCollectionViewAnimationLinkKey : link
    };
    [[self class] bk_associateValue: data withKey: &TFCollectionViewAnimationDataKey];

    [link addToRunLoop: [NSRunLoop mainRunLoop] forMode: NSRunLoopCommonModes];

    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self.collectionView startInteractiveTransitionToCollectionViewLayout: layout completion: ^(BOOL completed, BOOL finish) {
        if (completion) {
            completion(completed, finish);
        }
    }];

}

- (void) updateTransitionProgress: (CADisplayLink *) link {

    UICollectionView *collectionView1 = self.collectionView;
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;

    //    if (collectionView1.delegate && [collectionView1.delegate respondsToSelector: @selector(collectionView:transitionLayoutForOldLayout:newLayout:)]) {
    //        [collectionView1.delegate collectionView: collectionView1 transitionLayoutForOldLayout: collectionView1.collectionViewLayout newLayout: layout];
    //    }

    if ([layout isKindOfClass: [UICollectionViewTransitionLayout class]]) {
        UICollectionViewTransitionLayout *transitionLayout = (UICollectionViewTransitionLayout *) layout;

        NSDictionary *data = [[self class] bk_associatedValueForKey: &TFCollectionViewAnimationDataKey];

        CFTimeInterval startTime = [data[TFCollectionViewAnimationStartTimeKey] floatValue];
        NSTimeInterval duration = [data[TFCollectionViewAnimationDurationKey] floatValue];

        CFTimeInterval time = duration > 0 ? ((link.timestamp - startTime) / duration) : 1;
        time = MIN(1, time);
        time = MAX(0, time);

        CGFloat progress = JKQuadraticOutInterpolation ? JKQuadraticOutInterpolation(time, 0, 1) : time;
        //        CGFloat progress = time;
        [transitionLayout setTransitionProgress: progress];

        if (time >= 1) {
            [self finishTransition: link];
        }
    } else {

        NSLog(@"layout = %@", layout);
        [self finishTransition: link];
    }

}

- (void) finishTransition: (CADisplayLink *) link {

    [link invalidate];
    //    NSDictionary *data = [[self class] bk_associatedValueForKey: &TFCollectionViewAnimationDataKey];
    // remove link from transition data as a signal that the transition is finalizing
    //    [data removeObjectForKey: @"link"];

    [[self class] bk_associateValue: @{} withKey: &TFCollectionViewAnimationDataKey];
    [self.collectionView finishInteractiveTransition];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}


#pragma mark - UICollectionView
- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [_images count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    //    TFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: TFCollectionViewCellIdentifier forIndexPath: indexPath];
    //
    //    TFPhoto *photo = [_images objectAtIndex: indexPath.item];
    //    [cell.imageView setImageWithURL: photo.URL];
    //    return cell;

    TFImageGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: TFCollectionViewCellIdentifier forIndexPath: indexPath];
    TFPhoto *photo = [_images objectAtIndex: indexPath.item];

    cell.infoButton.tag = indexPath.item;
    cell.backgroundColor = [UIColor clearColor];
    cell.opaque = NO;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    //    __weak TFImageGridViewCell *weakCell = cell;
    //
    ////    void (^presentationBlock)(UIImage *image) = ^(UIImage *image) {
    ////
    ////        __strong TFImageGridViewCell *strongCell = weakCell;
    ////        if (strongCell) {
    ////            strongCell.imageView.image = image;
    ////            [UIView animateWithDuration: 0.4 animations: ^{
    ////                strongCell.alpha = 1;
    ////            }];
    ////        }
    ////    };
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

    //    [self _notifyDequeuedCell: cell atIndexPath: indexPath];


    return cell;
}


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {

    if (_isFullscreen) {
        [self.navigationController popViewControllerAnimated: YES];

    } else {
        TFCollectionViewController *controller = [[TFCollectionViewController alloc] initWithCollectionViewLayout: [[TFCollectionViewFullLayout alloc] init]];
        controller.useLayoutToLayoutNavigationTransitions = YES;
        [self.navigationController pushViewController: controller animated: YES];
    }

    return;

}


- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
    TFCollectionTransitionLayout *ret = [[TFCollectionTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    return ret;
}


//
//#pragma mark - UICollectionViewDelegateFlowLayout
//
//- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumLineSpacingForSectionAtIndex: (NSInteger) section {
//    //
//    //    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
//    //        return [_delegate collectionView: collectionView layout: collectionViewLayout minimumLineSpacingForSectionAtIndex: section];
//    //    }
//    return 0;
//}
//
//- (CGFloat) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout minimumInteritemSpacingForSectionAtIndex: (NSInteger) section {
//    //    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
//    //        return [_delegate collectionView: collectionView layout: collectionViewLayout minimumInteritemSpacingForSectionAtIndex: section];
//    //    }
//    return 0;
//}
//
//- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
//    //    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
//    //        return [_delegate collectionView: collectionView layout: collectionViewLayout sizeForItemAtIndexPath: indexPath];
//    //    }
//    if (_isFullscreen) {
//        return self.view.bounds.size;
//    } else {
//
//        CGFloat cellHeight = self.view.height / 3;
//        return CGSizeMake(cellHeight, cellHeight);
//    }
//}
//
//- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
//    //    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:insetForSectionAtIndex:)]) {
//    //        return [_delegate collectionView: collectionView layout: collectionViewLayout insetForSectionAtIndex: section];
//    //    }
//    return _isFullscreen ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(-22, 0, 0, 0);
//}

//
//- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
//    //    if (_delegate && [_delegate respondsToSelector: @selector(collectionView:layout:transitionLayoutForOldLayout:newLayout:)]) {
//    //        return [_delegate collectionView: collectionView transitionLayoutForOldLayout: fromLayout newLayout: toLayout];
//    //    }
//    return nil;
//}


#pragma mark - Dealloc

- (void) dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    self.collectionView = nil;

}

@end