//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMindmapCollectionViewController.h"
#import "APIModel.h"
#import "TFCollectionViewFullLayout.h"
#import "TFCollectionTransitionLayout.h"
#import "TFFullLayout.h"
#import "UICollectionView+TLTransitioning.h"
#import "NSObject+BKAssociatedObjects.h"
#import "TFNewMindmapLayout.h"
#import "UIView+DPConstraints.h"
#import "TFMindmapLayout.h"
#import "TFImageGridViewCell.h"
#import "TFMindmapFullCollectionViewController.h"
#import "TFMindmapTransitionLayout.h"
#import "TFNewMindmapLayout.h"


@implementation TFMindmapCollectionViewController {

}

- (void) setNode: (TFNode *) node {
    _node = node;

    [[APIModel sharedModel] getImages: _node.title
            success: ^(NSArray *imageArray) {
                self.images = imageArray;
            }
            failure: nil];
}


- (void) setNode: (TFNode *) node images: (NSArray *) images {
    _node = node;
    self.images = images;

}


- (TFMindmapLayout *) preparedLayout {
    return nil;
}

- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {

    NSLog(@"SETTING NOW.");

    TFMindmapLayout *currentLayout = (TFMindmapLayout *) self.collectionView.collectionViewLayout;

    //    TFNewMindmapLayout *layout = self.isFullscreen ? [self gridCollectionLayout] : [self fullscreenLayout];
    TFMindmapLayout *layout = [[TFMindmapLayout alloc] init];
    [layout setIsFullscreen: !currentLayout.isFullscreen withCollectionView: self.collectionView];


    DDLogVerbose(@"Will start transition.");
    [self transitionToLayout: layout
            duration: 0.45
            completion: ^(BOOL completed, BOOL finish) {
                self.isFullscreen = !self.isFullscreen;

                TFMindmapFullCollectionViewController *controller = [[TFMindmapFullCollectionViewController alloc] init];
                [controller setNode: _node images: self.images];
                controller.initialIndexPath = indexPath;
                [self.navigationController pushViewController: controller animated: NO];

                self.collectionView.collectionViewLayout = currentLayout;
                self.collectionView.pagingEnabled = NO;

            }];

    return;
}


- (TFNewMindmapLayout *) gridCollectionLayout {
    TFNewMindmapLayout *finalLayout = [[TFNewMindmapLayout alloc] init];
    finalLayout.numberOfRows = 3;
    finalLayout.updatesContentOffset = YES;

    CGFloat height = self.view.height;
    finalLayout.itemSize = CGSizeMake(height, height);
    return finalLayout;
}

- (TFNewMindmapLayout *) fullscreenLayout {
    TFNewMindmapLayout *finalLayout = [[TFNewMindmapLayout alloc] init];
    finalLayout.numberOfRows = 1;
    finalLayout.updatesContentOffset = YES;

    finalLayout.itemSize = self.view.bounds.size;
    return finalLayout;
}

//

#pragma mark - UICollectionView

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFImageGridViewCell *cell = (TFImageGridViewCell *) [super collectionView: collectionView cellForItemAtIndexPath: indexPath];
    cell.overlayView.alpha = 1;
    return cell;
}


- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    //    return UIEdgeInsetsMake(-22, 0, 0, 0);
    return self.isFullscreen ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(-22, 0, 0, 0);
}


- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
    TFMindmapTransitionLayout *ret = [[TFMindmapTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    return ret;
}


@end