//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import <DPAnimators/NavigationFadeAnimator.h>
#import "TFMindmapBackgroundCollectionViewController.h"
#import "TFContentViewNavigationController.h"
#import "TFMindmapButtonsViewController.h"
#import "TFNode.h"
#import "TFContentView.h"
#import "TFMindmapCollectionViewController.h"
#import "TFCollectionAnimator.h"
#import "TFMindmapFullscreenViewController.h"
#import "TFMindmapFullCollectionViewController.h"
#import "TFNewImageDrawerViewController.h"
#import "Project.h"
#import "TFPhoto.h"


@interface TFMindmapBackgroundCollectionViewController ()

@property(nonatomic, strong) TFCollectionAnimator *animator;
@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;

@property(nonatomic, strong) TFMindmapButtonsViewController *buttonsController;
@property(nonatomic, strong) TFContentViewNavigationController *contentController;
@property(nonatomic, strong) TFMindmapCollectionViewController *initialController;
@end

@implementation TFMindmapBackgroundCollectionViewController

- (instancetype) initWithContentView: (TFContentView *) contentView project: (Project *) project node: (TFNode *) node {
    self = [super init];
    if (self) {
        _contentView = contentView;
        _project = project;
        _node = node;

        _animator = [TFCollectionAnimator new];

        _fadeAnimator = [NavigationFadeAnimator new];
        _fadeAnimator.transitionDuration = 2.0;

        _initialController = [[TFMindmapCollectionViewController alloc] init];

        _contentController = [[TFContentViewNavigationController alloc] initWithRootViewController: _initialController];

        _buttonsController = [[TFMindmapButtonsViewController alloc] init];
        _buttonsController.delegate = self;
    }

    return self;
}

- (instancetype) initWithContentView: (TFContentView *) contentView {
    self = [super init];
    if (self) {
        _contentView = contentView;

    }

    return self;
}


- (void) loadView {
    self.view = [[UIView alloc] init];

    _contentController.navigationBarHidden = YES;
    _contentController.delegate = self;
    _contentController.contentView = _contentView;
    //    _contentController.edgesForExtendedLayout = UIRectEdgeNone;
    [self embedFullscreenController: _contentController];

    [self embedFullscreenController: _buttonsController];

}


- (void) viewDidLoad {
    [super viewDidLoad];

}


- (void) setNode: (TFNode *) node {
    _node = node;

    //    _initialController.node = _node;

    TFMindmapCollectionViewController *controller = (TFMindmapCollectionViewController *) _contentController.visibleViewController;
    controller.node = _node;
}


#pragma mark -  UINavigationControllerDelegate

//- (id <UIViewControllerInteractiveTransitioning>) navigationController: (UINavigationController *) navigationController interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>) animationController {
//    return nil;
//}

//- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
//    if (operation == UINavigationControllerOperationPush) {
//        _fadeAnimator.isPresenting = YES;
//    } else if (operation == UINavigationControllerOperationPop) {
//        _fadeAnimator.isPresenting = NO;
//    }
//    return _fadeAnimator;
//}



- (void) navigationController: (UINavigationController *) navigationController willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {

    BOOL isFullscreen = [viewController isKindOfClass: [TFMindmapFullCollectionViewController class]];

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

    if ([viewController isKindOfClass: [TFMindmapFullCollectionViewController class]]) {
        TFMindmapFullCollectionViewController *controller = (TFMindmapFullCollectionViewController *) viewController;
        controller.delegate = self;
    }

}



#pragma mark - TFMindmapButtonsViewControllerDelegate



- (void) buttonsController: (TFMindmapButtonsViewController *) buttonsViewController tappedButtonWithType: (TFMindmapButtonType) type {

    switch (type) {

        case TFMindmapButtonTypeGrid : {
            [_contentController popToRootViewControllerAnimated: YES];
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
            if ([_contentController.visibleViewController isKindOfClass: [TFMindmapFullCollectionViewController class]]) {
                UIButton *button = [buttonsViewController buttonForType: type];
                button.selected = !button.selected;

                TFPhoto *image = _selectedImage;

                if (button.selected) {
                    if (![_project.pinnedImages containsObject: image]) {
                        [_project addPin: image];
                    }

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


- (void) mindmapCollectionViewController: (TFMindmapFullCollectionViewController *) controller selectedImage: (TFPhoto *) image {
    _selectedImage = image;

    if (_contentController.isOpen) {
        if ([_contentController.rightDrawerController isKindOfClass: [TFNewImageDrawerViewController class]]) {
            TFNewImageDrawerViewController *imageDrawerViewController = (TFNewImageDrawerViewController *) _contentController.rightDrawerController;
            imageDrawerViewController.image = image;
        }
    }

    [self _refreshButtonsController];
}


#pragma mark - TFNewImageDrawerViewControllerDelegate

- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController removedPin: (TFPhoto *) image {
    [self _refreshButtonsController];
}

- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController addedPin: (TFPhoto *) image {
    [self _refreshButtonsController];
}

#pragma mark - Refresh
- (void) _refreshButtonsController {
    [_buttonsController updatePinButtonForImage: _selectedImage inProject: _project];
}


@end