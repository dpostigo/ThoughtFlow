//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import "TFNewMindmapBackgroundViewController.h"
#import "Project.h"
#import "TFNode.h"
#import "UIViewController+TFControllers.h"
#import "MindmapBackgroundController.h"
#import "UIViewController+TFContentNavigationController.h"
#import "TFContentViewNavigationController.h"
#import "TFMindmapGridViewController.h"
#import "TFNewMindmapGridViewController.h"
#import "TFNewMindmapFullscreenViewController.h"
#import "TFImageDrawerViewController.h"
#import "APIModel.h"


@implementation TFNewMindmapBackgroundViewController

- (instancetype) initWithProject: (Project *) project node: (TFNode *) node {
    self = [super init];
    if (self) {
        _project = project;
        _node = node;
    }

    return self;
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupControllers];
}



#pragma mark - Public

- (void) setNode: (TFNode *) node {
    _node = node;
    if (_node && self.isViewLoaded) {
        self.imageString = _node.title;
    }
}

- (void) setImageString: (NSString *) imageString {
    _imageString = [imageString mutableCopy];
    [[APIModel sharedModel] getImages: _imageString success: ^(NSArray *imageArray) {
        self.images = imageArray;
        //        [self.collection scrollToItemAtIndexPath: [NSIndexPath indexPathForItem: 0 inSection: 0] atScrollPosition: UICollectionViewScrollPositionNone animated: NO];
        //            [UIView animateWithDuration: 0.4 animations: ^{
        //                self.collection.alpha = 1;
        //            }];

    } failure: nil];
}


- (void) setImages: (NSArray *) images {
    _images = images;
    self.currentImageController.images = _images;
}






#pragma mark - TFMindmapButtonsViewControllerDelegate

- (void) buttonsController: (TFMindmapButtonsViewController *) buttonsViewController tappedButtonWithType: (TFMindmapButtonType) type {

    switch (type) {

        case TFMindmapButtonTypeGrid : {
            TFNewMindmapFullscreenViewController *controller = [[TFNewMindmapFullscreenViewController alloc] initWithProject: _project images: _images];
            [_contentController toggleViewController: controller animated: YES];
        }
            break;

        case TFMindmapButtonTypeInfo : {
            self.contentNavigationController.rightDrawerController = [[TFImageDrawerViewController alloc] initWithImage: self.currentImageController.selectedImage];
            [self.contentNavigationController openRightContainer];
        }
            break;

        case TFMindmapButtonTypePin : {

        }
            break;

        default :
            break;
    }

}



#pragma mark - UINavigationControllerDelegate

- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    BOOL isFullscreen = [viewController isKindOfClass: [TFNewMindmapFullscreenViewController class]];

    _buttonsController.view.hidden = NO;
    [UIView animateWithDuration: 0.4
            delay: 0.0f
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


- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    self.fadeAnimator.isPresenting = operation == UINavigationControllerOperationPush ? YES : NO;
    return self.fadeAnimator;
}


#pragma mark - Private

- (void) _setupControllers {

    TFNewMindmapGridViewController *controller = [[TFNewMindmapGridViewController alloc] initWithProject: _project images: _images];
    TFNewMindmapFullscreenViewController *controller2 = [[TFNewMindmapFullscreenViewController alloc] initWithProject: _project images: _images];

    _contentController = [[TFContentViewNavigationController alloc] initWithRootViewController: controller];
    _contentController.navigationBarHidden = YES;
    _contentController.delegate = self;
    [_contentController pushViewController: controller2 animated: NO];
    [self embedFullscreenController: _contentController];

    _buttonsController = (TFMindmapButtonsViewController *) self.mindmapButtonsController;
    _buttonsController.delegate = self;
    [self embedFullscreenController: _buttonsController];

}


- (TFNewMindmapGridViewController *) currentImageController {
    return (TFNewMindmapGridViewController *) _contentController.visibleViewController;
}

- (NavigationFadeAnimator *) fadeAnimator {
    if (_fadeAnimator == nil) {
        _fadeAnimator = [NavigationFadeAnimator new];
    }
    return _fadeAnimator;
}


@end