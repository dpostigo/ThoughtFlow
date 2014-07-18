//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFMoodboardFullscreenViewController.h"
#import "TFImageGridViewCell.h"
#import "UIViewController+TFContentNavigationController.h"
#import "TFContentViewNavigationController.h"
#import "TFPhoto.h"
#import "TFNewImageDrawerViewController.h"
#import "Project.h"


@interface TFMoodboardFullscreenViewController ()

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation TFMoodboardFullscreenViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    _selectedIndexPath = [NSIndexPath indexPathForItem: 0 inSection: 0];
    _buttonsController = [[TFCornerButtonsViewController alloc] init];
    _buttonsController.delegate = self;
    [self embedFullscreenController: _buttonsController];

    [_buttonsController.topLeftButton setImage: [UIImage imageNamed: @"grid-icon"] forState: UIControlStateNormal];
    [_buttonsController.topRightButton setImage: [UIImage imageNamed: @"info-button-icon"] forState: UIControlStateNormal];
    [_buttonsController.bottomRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateNormal];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    if (_selectedImage) {
        [self.view layoutIfNeeded];
        [self.imagesController scrollToImage: self.selectedImage];
    }
}


#pragma mark - Delegates
#pragma mark - TFCornerButtonsViewControllerDelegate

- (void) buttonsController: (TFCornerButtonsViewController *) cornerButtonsViewController clickedButtonWithType: (TFCornerType) type {

    switch (type) {
        case TFCornerTypeTopLeft : {
            [self.navigationController popViewControllerAnimated: YES];
        }
            break;

        case TFCornerTypeTopRight : {
            //            TFPhoto *image = [self.imagesController.images objectAtIndex: indexPath.item];
            self.contentNavigationController.rightDrawerController = [[TFNewImageDrawerViewController alloc] initWithProject: self.project image: _selectedImage];
            [self.contentNavigationController openRightContainer];
            break;
        }

        case TFCornerTypeBottomRight : {
            [self deleteItemAtIndexPath: _selectedIndexPath completion: ^{

                if ([self.project.pinnedImages count] == 0) {
                    [UIView animateWithDuration: 0.4 animations: ^{
                        _buttonsController.view.alpha = 0;
                    }];
                    //
                } else {
                    [UIView animateWithDuration: 0.4 animations: ^{
                        _buttonsController.view.alpha = 1;
                    }];
                }

            }];
            break;
        }

        case TFCornerTypeBottomLeft :
        case TFCornerTypeNone :
        default :
            break;
    }

}


#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    //
    //    [cell.topLeftButton setImage: [UIImage imageNamed: @"grid-icon"] forState: UIControlStateNormal];
    //    [controller addTargetToButton: cell.topLeftButton];
    //
    //    [cell.topRightButton setImage: [UIImage imageNamed: @"info-button-icon"] forState: UIControlStateNormal];
    //    [controller addTargetToButton: cell.topRightButton];
    //
    //    [cell.bottomRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateNormal];
    //    [controller addTargetToButton: cell.bottomRightButton];

}


- (void) imageGridViewController: (TFImageGridViewController *) gridViewController didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    if (button == cell.topLeftButton) {
        [self.navigationController popViewControllerAnimated: YES];

    } else if (button == cell.topRightButton) {

        self.contentNavigationController.rightDrawerController = [[TFNewImageDrawerViewController alloc] initWithProject: self.project image: _selectedImage];
        [self.contentNavigationController openRightContainer];

    } else if (button == cell.bottomRightButton) {

    }
}


- (void) imageGridViewController: (TFImageGridViewController *) controller didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {

}


- (void) imageGridViewController: (TFImageGridViewController *) imageGridViewController didScrollToImage: (TFPhoto *) image {
    _selectedImage = image;

    if (self.contentNavigationController.isOpen) {
        if ([self.contentNavigationController.rightDrawerController isKindOfClass: [TFNewImageDrawerViewController class]]) {
            TFNewImageDrawerViewController *controller = (TFNewImageDrawerViewController *) self.contentNavigationController.rightDrawerController;
            controller.image = image;
        }
    }

}


- (void) imageGridViewController: (TFImageGridViewController *) controller didScrollToIndexPath: (NSIndexPath *) indexPath {
    _selectedIndexPath = indexPath;

}



#pragma mark - UICollectionViewLayout

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return self.view.bounds.size;
}





#pragma mark - Private

- (void) _setupControllers {
    [super _setupControllers];

    self.imagesController.collection.pagingEnabled = YES;
}


@end