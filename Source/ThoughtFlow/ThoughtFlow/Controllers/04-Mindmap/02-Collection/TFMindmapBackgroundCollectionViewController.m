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


@interface TFMindmapBackgroundCollectionViewController ()

@property(nonatomic, strong) TFCollectionAnimator *animator;
@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;
@property(nonatomic, strong) TFContentViewNavigationController *contentController;
@property(nonatomic, strong) TFMindmapCollectionViewController *initialController;
@end

@implementation TFMindmapBackgroundCollectionViewController

- (instancetype) initWithContentView: (TFContentView *) contentView {
    self = [super init];
    if (self) {
        _contentView = contentView;

        _animator = [TFCollectionAnimator new];

        _fadeAnimator = [NavigationFadeAnimator new];
        _fadeAnimator.transitionDuration = 2.0;

        _initialController = [[TFMindmapCollectionViewController alloc] init];
        //[_initialController.view addDebugBorder: [UIColor yellowColor]];

        _contentController = [[TFContentViewNavigationController alloc] initWithRootViewController: _initialController];

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

    //    [self _loadContentController];
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


@end