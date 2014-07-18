//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFMindmapFullscreenViewController.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "TFUserPreferences.h"
#import "APIModel.h"
#import "NSObject+BKBlockObservation.h"
#import "APIUser.h"


@interface TFMindmapFullscreenViewController ()

@property(nonatomic, strong) UIImageView *bg;
@property(nonatomic, strong) TFUserPreferences *preferences;
@end

@implementation TFMindmapFullscreenViewController


#pragma mark - View lifecycle




- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    UIView *view = self.imagesController.view;
    view.alpha = _preferences.imageSearchEnabled ? 1 : 0;
    view.hidden = !_preferences.imageSearchEnabled;

}



#pragma mark - Setup

//
//- (void) _setup {
//    [super _setup];

//
//}


- (void) _setup {
    [super _setup];

    _bg = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"texture"]];
    _bg.frame = self.view.bounds;
    [self embedFullscreenView: _bg];
    [self.view sendSubviewToBack: _bg];

    [self _setupUserPreferences];
}


- (void) _setupUserPreferences {
    _preferences = [APIModel sharedModel].currentUser.preferences;

    UIView *view = self.imagesController.view;

    [self bk_addObserverForKeyPath: @"preferences.imageSearchEnabled" task: ^(id target) {
        view.hidden = NO;

        BOOL shouldShowView = self.preferences.imageSearchEnabled;
        [UIView animateWithDuration: 0.4 delay: 00.
                usingSpringWithDamping: 2.0
                initialSpringVelocity: 0.8
                options: UIViewAnimationOptionCurveLinear
                animations: ^() {

                    view.alpha = shouldShowView ? 1 : 0;
                    _bg.alpha = shouldShowView ? 0 : 1;
                }
                completion: ^(BOOL finished) {
                    view.hidden = !shouldShowView;
                    _bg.hidden = !shouldShowView;

                }];
    }];

}


#pragma mark - Delegates

- (void) imageGridViewController: (TFImageGridViewController *) gridViewController didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    // TODO : Does this ever get called?

    //    if (button == cell.topLeftButton) {
    //        [self.navigationController popViewControllerAnimated: YES];
    //
    //    } else if (button == cell.topRightButton) {
    //        TFPhoto *image = [gridViewController.images objectAtIndex: indexPath.item];
    //        //        TFImageDrawerViewController *controller = [[TFImageDrawerViewController alloc] initWithProject: self.project image: image];
    //        TFNewImageDrawerViewController *controller = [[TFNewImageDrawerViewController alloc] initWithProject: self.project image: image];
    //
    //        self.contentNavigationController.rightDrawerController = controller;
    //        [self.contentNavigationController openRightContainer];
    //
    //    } else if (button == cell.bottomRightButton) {
    //
    //    }
}


- (void) imageGridViewController: (TFImageGridViewController *) controller didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {

}

- (void) imageGridViewController: (TFImageGridViewController *) controller didScrollToImage: (TFPhoto *) image {
    self.selectedImage = image;
    [self _notifySelection: image];
}


#pragma mark - UICollectionViewLayout

- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return self.view.bounds.size;
}


- (UIEdgeInsets) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout insetForSectionAtIndex: (NSInteger) section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma mark - Private

- (void) _setupControllers {
    [super _setupControllers];

    self.imagesController.collection.pagingEnabled = YES;
    self.imagesController.selectedImage = self.selectedImage;

}

@end