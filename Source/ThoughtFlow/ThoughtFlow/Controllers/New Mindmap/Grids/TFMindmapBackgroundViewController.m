//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import <TWTToast/TWTNavigationControllerDelegate.h>
#import <TWTPopTransitionController/TWTPopTransitionController.h>
#import "TFMindmapBackgroundViewController.h"
#import "Project.h"
#import "TFNode.h"
#import "TFContentViewNavigationController.h"
#import "TFNewMindmapGridViewController.h"
#import "TFMindmapFullscreenViewController.h"
#import "APIModel.h"
#import "TFPhoto.h"
#import "TFMindmapGridAnimator.h"


@interface TFMindmapBackgroundViewController ()

@property(nonatomic, strong) TFMindmapButtonsViewController *buttonsController;
@property(nonatomic, strong) TFNewMindmapGridViewController *gridController;
@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;
@property(nonatomic, strong) TWTPopTransitionController *popTransitionController;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property(nonatomic, strong) TFMindmapGridAnimator *gridAnimator;
@end

@implementation TFMindmapBackgroundViewController

- (instancetype) initWithProject: (Project *) project node: (TFNode *) node {
    self = [super init];
    if (self) {
        _project = project;
        _node = node;

        _fadeAnimator = [NavigationFadeAnimator new];

        if (DEV) {
            _popTransitionController = [[TWTPopTransitionController alloc] init];
            _popTransitionController.delegate = self;
            _pinchRecognizer = _popTransitionController.pinchGestureRecognizer;

            _gridAnimator = [TFMindmapGridAnimator new];
        }
    }

    return self;
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self _setupControllers];
    self.node = _node;
}


#pragma mark - Public

- (void) setNode: (TFNode *) node {
    _node = node;
    self.imageString = _node.title;
}

- (void) setImageString: (NSString *) imageString {
    if ([imageString isEqualToString: _imageString]) return;
    _imageString = [imageString mutableCopy];

    [[APIModel sharedModel] getImages: _imageString
            success: ^(NSArray *imageArray) {
                self.images = imageArray;
            }
            failure: nil];
}

- (void) setImages: (NSArray *) images {
    _images = images;

    if ([_images count] > 0) {
        _selectedImage = _images[0];
    }
    if (self.isViewLoaded) {

        if ([_contentController.visibleViewController isKindOfClass: [TFMindmapFullscreenViewController class]]) {
            TFMindmapFullscreenViewController *controller = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
            controller.images = _images;
            controller.delegate = self;
            [_contentController pushViewController: controller animated: YES];
        }

        _gridController.images = _images;
        //        self.currentImageController.images = _images;
        //
        //        if (_fullscreenController2) {
        //            _fullscreenController2.images = _images;
        //        }
    }

    [[APIModel sharedModel] preloadImages: _images];
}


- (void) setMindmapType: (TFMindmapControllerType) mindmapType {
    _mindmapType = mindmapType;

    TFNewMindmapGridViewController *controller = (TFNewMindmapGridViewController *) _contentController.visibleViewController;
    controller.isMinimized = _mindmapType == TFMindmapControllerTypeMinimized;

    self.isMinimized = _mindmapType == TFMindmapControllerTypeMinimized;
}

- (void) setIsMinimized: (BOOL) isMinimized {
    _isMinimized = isMinimized;
    _pinchRecognizer.enabled = _isMinimized;
    _gridAnimator.enabled = _isMinimized;
}


#pragma mark - Delegates


#pragma mark - TWTTransitionControllerDelegate
- (void) transitionControllerInteractionDidStart: (id <TWTTransitionController>) transitionController {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    //    if (_gridController == nil) {
    //
    //        NSLog(@"_gridController = %@", _gridController);
    //        return;
    //    }
    //
    //    if (_gridController != nil) {
    //
    //        if (self.isFullscreen) {
    //            TFMindmapFullscreenViewController *fullController = (TFMindmapFullscreenViewController *) _contentController.visibleViewController;
    //
    //            NSIndexPath *indexPath = fullController.selectedIndexPath;
    //
    //            UICollectionView *collectionView = _gridController.imagesController.collection;
    //
    //            //            _gridController.collectionView
    //
    //            UICollectionViewCell *cell = [_gridController.collectionView cellForItemAtIndexPath: indexPath];
    //
    //            NSLog(@"cell = %@", cell);
    //
    //            CGRect rect = cell.frame;
    //
    //
    //            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //            layout.itemSize = rect.size;
    //            [fullController.collectionView setCollectionViewLayout: layout animated: YES];
    //
    //        }
    //
    //    }

    [_contentController popToRootViewControllerAnimated: YES];

}



#pragma mark - TFNewImageDrawerViewControllerDelegate
- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController removedPin: (TFPhoto *) image {
    [self _refreshButtonsController];
}

- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController addedPin: (TFPhoto *) image {
    [self _refreshButtonsController];
}

#pragma mark - TFMindmapButtonsViewControllerDelegate


- (void) buttonsController: (TFMindmapButtonsViewController *) buttonsViewController tappedButtonWithType: (TFMindmapButtonType) type {

    switch (type) {

        case TFMindmapButtonTypeGrid : {
            [_contentController popToRootViewControllerAnimated: YES];
            //            TFMindmapFullscreenViewController *controller = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
            //            [_contentController toggleViewController: controller animated: YES];
        }
            break;

        case TFMindmapButtonTypeInfo : {
            TFNewImageDrawerViewController *controller = [[TFNewImageDrawerViewController alloc] initWithProject: _project image: _selectedImage];
            controller.delegate = self;
            _contentController.rightDrawerController = controller;
            [_contentController openRightContainer];

        }
            break;

        case TFMindmapButtonTypePin : {
            if ([_contentController.visibleViewController isKindOfClass: [TFMindmapFullscreenViewController class]]) {

                UIButton *button = [buttonsViewController buttonForType: type];
                button.selected = !button.selected;

                TFPhoto *image = _selectedImage;

                if (button.selected) {
                    if (![_project.pinnedImages containsObject: image]) {
                        //                        [_project.pinnedImages addObject: image];
                        [_project addPin: image];
                    }

                    //                    [self.currentImageController.imagesController reloadImage: image];

                } else {
                    if ([_project.pinnedImages containsObject: image]) {
                        [_project removePin: image];
                    }
                }

            }

        }
            break;

        default :
            break;
    }

}


#pragma mark - APLTransitionControllerDelegate

- (void) interactionBeganAtPoint: (CGPoint) p {

    //    UINavigationController *navController = (UINavigationController *) self.view.window.rootViewController;

    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op.
    //
//    UIViewController *viewController = [(APLCollectionViewController *) _contentController.topViewController nextViewControllerAtPoint: p];
    //    if (viewController != nil) {
    //        [_contentController pushViewController: viewController animated: YES];
    //    }
    //    else {
    //        [_contentController popViewControllerAnimated: YES];
    //    }
}


#pragma mark - UINavigationControllerDelegate



- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    BOOL isFullscreen = [viewController isKindOfClass: [TFMindmapFullscreenViewController class]];

    _buttonsController.view.hidden = NO;
    [UIView animateWithDuration: 0.5
            delay: 0.2
            usingSpringWithDamping: 0.8
            initialSpringVelocity: 2.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{
                _buttonsController.view.alpha = isFullscreen ? 1 : 0;
            }
            completion: ^(BOOL finished) {
                _buttonsController.view.hidden = !isFullscreen;
            }];

}

- (void) navigationController: (UINavigationController *) navigationController didShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    if (DEV) {
        if (_pinchRecognizer.view) {
            [_pinchRecognizer.view removeGestureRecognizer: _pinchRecognizer];
        }

        [self.view addGestureRecognizer: _pinchRecognizer];
        _pinchRecognizer.enabled = _mindmapType == TFMindmapControllerTypeMinimized;

        viewController.twt_popAnimationController = _popTransitionController;
    }

    TFNewMindmapGridViewController *controller = (TFNewMindmapGridViewController *) _contentController.visibleViewController;
    _gridAnimator.collectionView = controller.collectionView;

}


- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController
                                    animationControllerForOperation: (UINavigationControllerOperation) operation
                                                 fromViewController: (UIViewController *) sourceController
                                                   toViewController: (UIViewController *) destinationController {

    if (DEV) {

        return _gridAnimator.hasActiveInteraction ? _gridAnimator : nil;
        if ([destinationController isKindOfClass: [TFMindmapFullscreenViewController class]]) {
            NavigationFadeAnimator *ret = self.fadeAnimator;

            if (operation == UINavigationControllerOperationPush) {
                ret.isPresenting = YES;
            } else if (operation == UINavigationControllerOperationPop) {
                ret.isPresenting = NO;
            } else {
                NSLog(@"help");

            }

            return _fadeAnimator;
        }
        return [_navigationDelegate navigationController: navigationController animationControllerForOperation: operation fromViewController: sourceController toViewController: destinationController];
    } else {
        NavigationFadeAnimator *ret = self.fadeAnimator;

        if (operation == UINavigationControllerOperationPush) {
            ret.isPresenting = YES;
        } else if (operation == UINavigationControllerOperationPop) {
            ret.isPresenting = NO;
        } else {

        }

        return _fadeAnimator;
    }

    return nil;

}


- (id <UIViewControllerInteractiveTransitioning>) navigationController: (UINavigationController *) navigationController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>) animationController {

    return _gridAnimator.hasActiveInteraction ? _gridAnimator : nil;
    //    return [_navigationDelegate navigationController: navigationController interactionControllerForAnimationController: animationController];
}


#pragma mark - TFMindmapImageControllerProtocol






- (void) imageController: (UIViewController *) imageController didSelectImage: (TFPhoto *) image {
    _selectedImage = image;

    if (_contentController.isOpen) {
        //        if ([_contentController.rightDrawerController isKindOfClass: [TFImageDrawerViewController class]]) {
        //            TFImageDrawerViewController *controller = (TFImageDrawerViewController *) _contentController.rightDrawerController;
        //            controller.image = image;
        //        }
        if ([_contentController.rightDrawerController isKindOfClass: [TFNewImageDrawerViewController class]]) {
            TFNewImageDrawerViewController *controller = (TFNewImageDrawerViewController *) _contentController.rightDrawerController;
            controller.image = image;
        }
    }

    [self _refreshButtonsController];
}

#pragma mark - Setup



- (void) _initSetup {
}


- (void) _setupControllers {

    _navigationDelegate = [[TWTNavigationControllerDelegate alloc] init];

    _gridController = [[TFNewMindmapGridViewController alloc] initWithProject: _project images: _images];
    _gridController.delegate = self;

    _contentController = [[TFContentViewNavigationController alloc] initWithRootViewController: _gridController];
    _contentController.navigationBarHidden = YES;
    _contentController.delegate = self;
    _contentController.contentView = _contentView;
    [self embedFullscreenController: _contentController];
    [self _setupFullscreenController];

    _buttonsController = [[TFMindmapButtonsViewController alloc] init];
    _buttonsController.delegate = self;
    [self embedFullscreenController: _buttonsController];

}

- (void) _setupFullscreenController {
    TFMindmapFullscreenViewController *controller2 = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
    controller2.delegate = self;

    [_contentController pushViewController: controller2 animated: YES];

}


- (TFNewMindmapGridViewController *) currentImageController {
    return (TFNewMindmapGridViewController *) ([_contentController.visibleViewController isKindOfClass: [TFNewMindmapGridViewController class]] ? _contentController.visibleViewController : nil);
}




#pragma mark - Refresh

- (void) _refreshButtonsController {
    [_buttonsController updatePinButtonForImage: _selectedImage inProject: _project];
}


- (BOOL) isFullscreen {
    return [_contentController.visibleViewController isKindOfClass: [TFMindmapFullscreenViewController class]];
}

@end