//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMoodboardFullscreenViewController.h"
#import "TFImageGridViewCell.h"
#import "UIViewController+TFContentNavigationController.h"
#import "TFContentViewNavigationController.h"
#import "UIViewController+TFControllers.h"
#import "TFPhoto.h"
#import "TFImageDrawerViewController.h"


@implementation TFMoodboardFullscreenViewController

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    [cell.topLeftButton setImage: [UIImage imageNamed: @"grid-icon"] forState: UIControlStateNormal];
    [controller addTargetToButton: cell.topLeftButton];

    [cell.topRightButton setImage: [UIImage imageNamed: @"info-button-icon"] forState: UIControlStateNormal];
    [controller addTargetToButton: cell.topRightButton];

    [cell.bottomRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateNormal];
    [controller addTargetToButton: cell.bottomRightButton];

}


- (void) imageGridViewController: (TFImageGridViewController *) gridViewController didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    if (button == cell.topLeftButton) {
        [self.navigationController popViewControllerAnimated: YES];

    } else if (button == cell.topRightButton) {

        TFPhoto *image = [gridViewController.images objectAtIndex: indexPath.item];
        self.contentNavigationController.rightDrawerController = [[TFImageDrawerViewController alloc] initWithImage: image];
        [self.contentNavigationController openRightContainer];

    } else if (button == cell.bottomRightButton) {

    }
}


- (void) imageGridViewController: (TFImageGridViewController *) controller didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {

}


#pragma mark - UICollectionViewLayout

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    CGSize result;
    return self.view.bounds.size;
}

@end