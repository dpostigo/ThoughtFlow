//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapCollectionViewController.h"
#import "APIModel.h"
#import "TFCollectionViewFullLayout.h"
#import "TFCollectionTransitionLayout.h"
#import "TFFullLayout.h"
#import "UICollectionView+TLTransitioning.h"
#import "NSObject+BKAssociatedObjects.h"
#import "UIView+DPConstraints.h"
#import "TFMindmapGridLayout.h"
#import "TFImageGridViewCell.h"
#import "TFMindmapFullCollectionViewController.h"


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

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    TFImageGridViewCell *cell = (TFImageGridViewCell *) [super collectionView: collectionView cellForItemAtIndexPath: indexPath];
    cell.overlayView.alpha = 1;
    return cell;
}

- (UICollectionViewTransitionLayout *) collectionView: (UICollectionView *) collectionView transitionLayoutForOldLayout: (UICollectionViewLayout *) fromLayout newLayout: (UICollectionViewLayout *) toLayout {
    UICollectionViewTransitionLayout *ret = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout: fromLayout nextLayout: toLayout];
    return ret;
    //    return [super collectionView: collectionView transitionLayoutForOldLayout: fromLayout newLayout: toLayout];
}


- (void) collectionView: (UICollectionView *) collectionView didSelectItemAtIndexPath: (NSIndexPath *) indexPath {

    //    [self.collectionView performBatchUpdates: ^{
    //
    //        self.collectionView.collectionViewLayout = [[TFCollectionViewFullLayout alloc] init];
    //        //        [self.collectionView.collectionViewLayout invalidateLayout];
    //        //        [self.collectionView setCollectionViewLayout: self.collectionView.collectionViewLayout animated: YES];
    //    } completion: ^(BOOL finished) {
    //    }];

    NSLog(@"SETTING NOW.");

    BOOL fullscreen = self.isFullscreen;
    TFCollectionTransitionLayout *transitionLayout;


    //    UICollectionViewLayout *currentLayout = self.collectionView.collectionViewLayout;
    //    UICollectionViewLayout *newLayout = self.isFullscreen ? self.gridLayout : self.fullLayout;


    //    CGSize size = self.collectionView.bounds.size;
    //    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [self.collectionView updateWidthConstraint: size.width];
    //    [self.collectionView updateHeightConstraint: size.height];
    //    [self.view layoutIfNeeded];

    //    [self.collectionView updateHeightConstraint: size.height * 2];
    //
    //    [UIView animateWithDuration: 0.4 animations: ^{
    //
    //        [self.view layoutIfNeeded];
    //    }];



    TFMindmapGridLayout *currentLayout = (TFMindmapGridLayout *) self.collectionView.collectionViewLayout;
    TFMindmapGridLayout *dynamicLayout = [[TFMindmapGridLayout alloc] init];
    [dynamicLayout setIsFullscreen: !currentLayout.isFullscreen withCollectionView: self.collectionView];





    //    dynamicLayout.sectionInset = UIEdgeInsetsMake(-22, 0, 0, 0);

    //    [self.collectionView setCollectionViewLayout: dynamicLayout animated: YES];
    //    return;

    DDLogVerbose(@"Will start transition.");
    [self transitionToLayout: dynamicLayout
            duration: 0.45
            completion: ^(BOOL completed, BOOL finish) {
                self.isFullscreen = !self.isFullscreen;
                NSLog(@"self.collectionView.collectionViewLayout = %@", self.collectionView.collectionViewLayout);

                //                if (self.isFullscreen) {
                TFMindmapFullCollectionViewController *controller = [[TFMindmapFullCollectionViewController alloc] init];
                [controller setNode: _node images: self.images];

                //                    self.useLayoutToLayoutNavigationTransitions = YES;
                [self.navigationController pushViewController: controller animated: YES];

                //                }
                //                if (self.isFullscreen) {
                //                    [self.navigationController popToRootViewControllerAnimated: NO];
                //
                //                } else {
                //                    TFMindmapCollectionViewController *controller = [[TFMindmapCollectionViewController alloc] initWithCollectionViewLayout: [[TFFullLayout alloc] init]];
                //                    controller.node = _node;
                //                    [self.navigationController pushViewController: controller animated: NO];
                //                }
                //
                //                self.collectionView.collectionViewLayout = currentLayout;

            }];

    return;
}

//
- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {
    //    return UIEdgeInsetsMake(-22, 0, 0, 0);
    return self.isFullscreen ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(-22, 0, 0, 0);
}

@end