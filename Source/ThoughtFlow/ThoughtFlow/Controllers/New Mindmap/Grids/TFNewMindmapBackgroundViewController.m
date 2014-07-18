//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import "TFNewMindmapBackgroundViewController.h"
#import "Project.h"
#import "TFNode.h"
#import "TFContentViewNavigationController.h"
#import "TFNewMindmapGridViewController.h"
#import "TFMindmapFullscreenViewController.h"
#import "APIModel.h"
#import "TFPhoto.h"
#import "TFNewMindmapFullscreenViewController.h"
#import "TFMoodboardFullscreenViewController.h"


@interface TFNewMindmapBackgroundViewController ()

@property(nonatomic, strong) TFMindmapButtonsViewController *buttonsController;
@property(nonatomic, strong) TFNewMindmapGridViewController *gridController;
@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;
@property(nonatomic, strong) TFNewMindmapFullscreenViewController *fullscreenController2;
@property(nonatomic, strong) TFMindmapFullscreenViewController *fullscreenController;
@end

@implementation TFNewMindmapBackgroundViewController

- (instancetype) initWithProject: (Project *) project node: (TFNode *) node {
    self = [super init];
    if (self) {
        _project = project;
        _node = node;
        [self _initSetup];
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

    _gridController.mindmapType = _mindmapType;
}



#pragma mark - Delegates
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


- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation
                                                 fromViewController: (UIViewController *) sourceController toViewController: (UIViewController *) destinationController {

    NavigationFadeAnimator *ret = self.fadeAnimator;

    if (operation == UINavigationControllerOperationPush) {
        NSLog(@"Push");
        ret.isPresenting = YES;
    } else if (operation == UINavigationControllerOperationPop) {
        NSLog(@"pop");

        ret.isPresenting = NO;
    } else {
        NSLog(@"help");

    }

    //        self.fadeAnimator.isPresenting = operation == UINavigationControllerOperationPush ? YES : NO;
    return _fadeAnimator;
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
    _fadeAnimator = [NavigationFadeAnimator new];
}

- (void) _setupControllers {

    _gridController = [[TFNewMindmapGridViewController alloc] initWithProject: _project images: _images];
    _gridController.delegate = self;

    TFMindmapFullscreenViewController *controller2 = [[TFMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
    controller2.delegate = self;

    //    _fullscreenController2 = [[TFNewMindmapFullscreenViewController alloc] initWithProject: _project images: _images];

    _contentController = [[TFContentViewNavigationController alloc] initWithRootViewController: _gridController];
    _contentController.navigationBarHidden = YES;
    _contentController.delegate = self;
    _contentController.contentView = _contentView;
    [_contentController pushViewController: controller2 animated: NO];
    [self embedFullscreenController: _contentController];

    _buttonsController = [[TFMindmapButtonsViewController alloc] init];
    _buttonsController.delegate = self;
    [self embedFullscreenController: _buttonsController];

}


- (TFNewMindmapGridViewController *) currentImageController {
    return (TFNewMindmapGridViewController *) ([_contentController.visibleViewController isKindOfClass: [TFNewMindmapGridViewController class]] ? _contentController.visibleViewController : nil);
}




#pragma mark - Refresh

- (void) _refreshButtonsController {
    [_buttonsController updatePinButtonForImage: _selectedImage inProject: _project];
}

@end