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
#import "TFMindmapBackgroundViewController.h"


@implementation TFNewMindmapGridViewController

- (instancetype) initWithProject: (Project *) project images: (NSArray *) images {
    self = [super init];
    if (self) {
        _project = project;
        _images = images;

    }
    return self;
}


- (void) loadView {
    self.view = [[UIView alloc] init];

    [self _setup];
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
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



#pragma mark - Getters

- (UICollectionView *) collectionView {
    return _imagesController.collection;
}


// obtain the next collection view controller based on where the user tapped in case there are multiple stacks
- (UICollectionViewController *) nextViewControllerAtPoint: (CGPoint) p {
    // we could have multiple section stacks, so we need to find the right one
//    UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
    //    grid.itemSize = CGSizeMake(75.0, 75.0);
    //    grid.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    //
    //    TFNewMindmapGridViewController *nextCollectionViewController = [[TFNewMindmapGridViewController alloc] initWithCollectionViewLayout: grid];
    //
    //    // Set "useLayoutToLayoutNavigationTransitions" to YES before pushing a a
    //    // UICollectionViewController onto a UINavigationController. The top view controller of
    //    // the navigation controller must be a UICollectionViewController that was pushed with
    //    // this property set to NO. This property should NOT be changed on a UICollectionViewController
    //    // that has already been pushed onto a UINavigationController.
    //    //
    //    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    //
    //    nextCollectionViewController.title = @"Grid Layout";
    //
    //    return nextCollectionViewController;
    return nil;
}

@end