//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapFullscreenViewController.h"
#import "TFImageGridViewCell.h"
#import "TFImageDrawerViewController.h"
#import "UIViewController+TFContentNavigationController.h"
#import "TFContentViewNavigationController.h"
#import "TFPhoto.h"


@implementation TFMindmapFullscreenViewController

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if (self.selectedImage) {
        NSLog(@"Selected image.");

        //        [self.view layoutIfNeeded];
        //        self.imagesController.selectedImage = self.selectedImage;
        //        [self.imagesController scrollToImage: self.selectedImage];
    }

}


- (void) imageGridViewController: (TFImageGridViewController *) gridViewController didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    if (button == cell.topLeftButton) {
        [self.navigationController popViewControllerAnimated: YES];

    } else if (button == cell.topRightButton) {
        TFPhoto *image = [gridViewController.images objectAtIndex: indexPath.item];
        self.contentNavigationController.rightDrawerController = [[TFImageDrawerViewController alloc] initWithProject: self.project image: image];
        [self.contentNavigationController openRightContainer];

    } else if (button == cell.bottomRightButton) {

    }
}


- (void) imageGridViewController: (TFImageGridViewController *) controller didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {

}

- (void) imageGridViewController: (TFImageGridViewController *) controller didScrollToImage: (TFPhoto *) image {
    self.selectedImage = image;
    [self _notifySelection: image];
}


#pragma mark - UICollectionViewLayout

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    CGSize result;
    return self.view.bounds.size;
}



#pragma mark - Private

- (void) _setupControllers {
    [super _setupControllers];

    self.imagesController.collection.pagingEnabled = YES;
    self.imagesController.selectedImage = self.selectedImage;

}

@end