//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewMindmapFullscreenViewController.h"
#import "UIViewController+TFControllers.h"
#import "TFImageGridViewCell.h"
#import "Project.h"
#import "TFPhoto.h"


@implementation TFNewMindmapFullscreenViewController

@synthesize selectedIndex;

- (instancetype) initWithProject: (Project *) project images: (NSArray *) images {
    self = [super init];
    if (self) {
        _project = project;
        _images = images;

        [self _setup];
    }

    return self;
}



#pragma mark - Public

- (void) setImages: (NSArray *) images {
    _images = images;
    _imagesController.images = images;

}



#pragma mark - Setup

- (void) _setup {
    [self _setupControllers];
    [self _setupRecognizers];
}

- (void) _setupControllers {
    _imagesController = [[TFImageGridViewController alloc] initWithImages: _images];
    _imagesController.delegate = self;
    _imagesController.images = _images;
    _imagesController.collection.pagingEnabled = YES;
    [self embedFullscreenController: _imagesController];

    _buttonsController = (TFMindmapButtonsViewController *) self.mindmapButtonsController;
    _buttonsController.delegate = self;
    [self embedFullscreenController: _buttonsController];

    //    [self _updateButtons];

}


- (void) _setupRecognizers {
    UICollectionView *collectionView = _imagesController.collection;
    NSLog(@"collectionView = %@", collectionView);
    for (UIGestureRecognizer *gestureRecognizer in collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
            panGesture.maximumNumberOfTouches = 1;
            //            panGesture.delegate = self;
        }
    }
}

- (void) _updateButtonsForImage: (TFPhoto *) image {
    if ([_project.pinnedImages containsObject: image]) {
        _buttonsController.pinButton.alpha = 0.5;
    } else {
        _buttonsController.pinButton.alpha = 1;

    }

}

#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.overlayView.alpha = 1;
}

- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    return;
}


- (void) imageGridViewController: (TFImageGridViewController *) gridController didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {
    //    TFMindmapFullscreenViewController *controller = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
    //    controller.selectedImage = image;
    //    [self.navigationController pushViewController: controller animated: YES];

}


- (void) imageGridViewController: (TFImageGridViewController *) controller didScrollToImage: (TFPhoto *) image {
    [self _updateButtonsForImage: image];

}


- (CGSize) collectionView: (UICollectionView *) collectionView layout: (UICollectionViewLayout *) collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *) indexPath {
    return self.view.bounds.size;
}




#pragma mark - TFMindmapButtonsViewControllerDelegate

- (void) buttonsController: (TFMindmapButtonsViewController *) buttonsViewController tappedButtonWithType: (TFMindmapButtonType) type {

    switch (type) {

        case TFMindmapButtonTypeGrid : {
            //                        TFMindmapFullscreenViewController *controller = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
            //                        [_contentController toggleViewController: controller animated: YES];
        }
            break;

        case TFMindmapButtonTypeInfo : {
            //                        self.contentNavigationController.rightDrawerController = [[TFImageDrawerViewController alloc] initWithImage: self.currentImageController.selectedImage];
            //                        [self.contentNavigationController openRightContainer];
        }
            break;

        case TFMindmapButtonTypePin : {
            //            if ([self.currentImageController isKindOfClass: [TFMindmapFullscreenViewController class]]) {
            //                TFPhoto *image = self.currentImageController.selectedImage;
            //                [_project.pinnedImages addObject: image];
            //                [self.currentImageController.imagesController reloadImage: image];
            //            }

        }
            break;

        default :
            break;
    }

}

@end