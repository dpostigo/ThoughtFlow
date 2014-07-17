//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewMindmapGridViewController.h"
#import "Project.h"
#import "TFImageGridViewCell.h"
#import "TFPhoto.h"
#import "TFMindmapFullscreenViewController.h"
#import "TFNewMindmapBackgroundViewController.h"


@implementation TFNewMindmapGridViewController

- (instancetype) initWithProject: (Project *) project images: (NSArray *) images {
    self = [super init];
    if (self) {
        _project = project;
        _images = images;

    }
    return self;
}



#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    [self _setup];
}




#pragma mark - Public

- (void) reloadVisibleItems {

    [_imagesController reloadVisibleItems];
}

- (void) setImages: (NSArray *) images {
    _images = images;
    _imagesController.images = _images;
}


- (void) setMindmapType: (TFMindmapControllerType) mindmapType {
    _mindmapType = mindmapType;
    [_imagesController reload];
}


#pragma mark - TFImageGridViewControllerDelegate

- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.overlayView.alpha = 1;

    if (_mindmapType == TFMindmapControllerTypeMinimized) {
        TFPhoto *photo = [controller.images objectAtIndex: indexPath.item];
        [cell.topRightButton setImage: [UIImage imageNamed: @"pin-button-icon"] forState: UIControlStateNormal];
        [cell.topRightButton setImage: [UIImage imageNamed: @"remove-button"] forState: UIControlStateSelected];
        cell.topRightButton.selected = [_project.pinnedImages containsObject: photo];
        [controller addTargetToButton: cell.topRightButton];

        cell.topRightButton.alpha = 0;

        [UIView animateWithDuration: 0.4
                delay: 0.0
                usingSpringWithDamping: 0.4
                initialSpringVelocity: 2.0
                options: UIViewAnimationOptionCurveLinear
                animations: ^{
                    //                    cell.topRightButton.alpha = 1;
                }
                completion: nil];

    }
}

- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    switch (_mindmapType) {
        case TFMindmapControllerTypeExpanded : {
            return;
        }
            break;

        case TFMindmapControllerTypeMinimized : {
            if (button == cell.topRightButton) {
                button.selected = !button.selected;

                TFPhoto *image = [_imagesController.images objectAtIndex: indexPath.item];
                if (button.selected) {

                    [_project addPin: image];
                    //                    [self _notifyAddedPin: image];

                } else {
                    [_project removePin: image];
                    //                    [self _notifyRemovedPin: _image];
                }
            }

        }
            break;
    }
}


- (void) imageGridViewController: (TFImageGridViewController *) gridController didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath {
    TFMindmapFullscreenViewController *controller = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
    controller.selectedImage = image;
    controller.delegate = _delegate;
    [self.navigationController pushViewController: controller animated: YES];
    [self _notifySelection: image];


    //    _delegate = nil;
}



#pragma mark - Setup


- (void) _setup {
    [self _setupView];
    [self _setupControllers];
    [self _setupProject];

}

- (void) _setupControllers {
    _imagesController = [[TFImageGridViewController alloc] initWithImages: _images];
    _imagesController.delegate = self;
    _imagesController.images = _images;
    [self embedFullscreenController: _imagesController];

}

- (void) _setupProject {

    if (_project) {

    }

    //    if (self.selectedImage) {
    //        [self.imagesController scrollToImage: self.selectedImage];
    //    }

    if (_selectedImage) {
        //        _imagesController.selectedImage = _selectedImage;

        //        [_imagesController scrollToImage: _selectedImage];
    }
}


- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}


- (void) _notifySelection: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(imageController:didSelectImage:)]) {
        [_delegate imageController: self didSelectImage: image];
    }
}

@end