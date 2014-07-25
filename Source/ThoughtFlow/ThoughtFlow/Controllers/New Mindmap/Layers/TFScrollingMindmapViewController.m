//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFScrollingMindmapViewController.h"
#import "TFNodesViewController.h"
#import "TFLinesViewController.h"
#import "UIView+DPKit.h"
#import "UIViewController+DPKit.h"
#import "DPPassThroughView.h"
#import "TFScrollView.h"
#import "TFScrollViewContentView.h"
#import "TFBaseNodeView.h"


@interface TFScrollingMindmapViewController ()

@property(nonatomic) BOOL isPinching;
@property(nonatomic) CGPoint startingOffset;
@property(nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic, strong) UIView *mindmapView;
@property(nonatomic, strong) TFScrollView *scrollView;
@end

@implementation TFScrollingMindmapViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        _maxContentOffset = CGSizeMake(0, 0);

    }

    return self;
}



#pragma mark - View lifecycle

- (void) loadView {
    self.view = [[DPPassThroughView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [self _setup];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    self.maxContentOffset = CGSizeMake(0, 0);
    [self.view layoutIfNeeded];

}




#pragma mark - Public



- (void) setMaxContentOffset: (CGSize) maxContentOffset {
    _maxContentOffset = maxContentOffset;
    _widthConstraint.constant = self.view.width + _maxContentOffset.width;
    _heightConstraint.constant = self.view.height + _maxContentOffset.height;
}


- (void) updateEdge: (CGPoint) maximumPoint withVelocity: (CGFloat) velocity {
    CGFloat padding = 20;
    if (maximumPoint.x > _widthConstraint.constant - padding ||
            maximumPoint.y > _heightConstraint.constant - padding) {
        CGPoint contentOffset = _scrollView.contentOffset;
        CGPoint newOffset = CGPointMake(contentOffset.x + velocity, contentOffset.y + velocity);

        _scrollView.contentOffset = newOffset;
    }

    return;

}

- (void) setMaximumPoint: (CGPoint) maximumPoint {

    CGFloat padding = 20;
    if (maximumPoint.x > _widthConstraint.constant - padding ||
            maximumPoint.y > _heightConstraint.constant - padding) {
        CGPoint contentOffset = _scrollView.contentOffset;
        CGPoint newOffset = CGPointMake(contentOffset.x + 1, contentOffset.y + 1);

        _scrollView.contentOffset = newOffset;
    }

    return;

}



#pragma mark - Public, Pinch

- (void) startPinchWithScale: (CGFloat) scale {
    _isPinching = YES;
    [_nodesController startPinchWithScale: scale];
}

- (void) updatePinchWithScale: (CGFloat) scale {
    [_nodesController updatePinchWithScale: scale];
}


- (void) endPinchWithScale: (CGFloat) scale {
    _isPinching = NO;
    [_nodesController endPinchWithScale: scale];
}


#pragma mark - Public, Pan

- (void) startPan: (UIPanGestureRecognizer *) recognizer {
    _startingOffset = _scrollView.contentOffset;

}

- (void) updatePan: (UIPanGestureRecognizer *) recognizer {
    CGPoint translation = [recognizer translationInView: recognizer.view];
    translation = CGPointMake(_startingOffset.x - translation.x, _startingOffset.y - translation.y);

    _scrollView.contentOffset = translation;

    self.maxContentOffset = CGSizeMake(translation.x, translation.y);

}

- (void) endPan: (UIPanGestureRecognizer *) recognizer {
    CGPoint offset = _scrollView.contentOffset;
    self.maxContentOffset = CGSizeMake(offset.x, offset.y);
    [self _refreshPinchPoint];
}


- (void) endNodeMove {

    CGPoint offset = _scrollView.contentOffset;
    self.maxContentOffset = CGSizeMake(offset.x, offset.y);
}

#pragma mark - Delegates
#pragma mark - UIScrollView






#pragma mark - Setup

- (void) _setup {

    _linesController = [[TFLinesViewController alloc] init];
    _nodesController = [[TFNodesViewController alloc] init];

    [self _setupScrollView];
    [self _setupMindmapView];
    [self _setupControllers];

    //    [_nodesController.view addDebugBorder: [UIColor redColor]];


}


- (void) _setupScrollView {
    _scrollView = [[TFScrollView alloc] initWithFrame: self.view.bounds];
    [self embedFullscreenView: _scrollView];

    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.zoomScale = 1.0;
    _scrollView.bounces = NO;

    //    _scrollView.
    //    _scrollView.userInteractionEnabled = NO;
    //    _scrollView.canCancelContentTouches = YES;
    //    _scrollView.delaysContentTouches = NO;
    [self _setupRecognizers];
}

- (void) _setupMindmapView {
    _mindmapView = [[TFScrollViewContentView alloc] initWithFrame: self.view.bounds];
    [_scrollView embedView: _mindmapView];

    _widthConstraint = [NSLayoutConstraint constraintWithItem: _mindmapView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: self.view.width + _maxContentOffset.width];
    _heightConstraint = [NSLayoutConstraint constraintWithItem: _mindmapView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: self.view.height + _maxContentOffset.height];

    [_scrollView addConstraints: @[
            _widthConstraint,
            _heightConstraint
    ]];

}

- (void) _setupControllers {
    [self embedController: _linesController inView: _mindmapView];
    [self embedController: _nodesController inView: _mindmapView];
}


- (void) _setupRecognizers {
    for (UIGestureRecognizer *gestureRecognizer in _scrollView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *) gestureRecognizer;
            panGesture.minimumNumberOfTouches = 2;
            //            panGesture.delegate = self;
        }
    }
}


- (void) updateViewConstraints {
    [super updateViewConstraints];

    _widthConstraint.constant = self.view.width + _maxContentOffset.width;
    _heightConstraint.constant = self.view.height + _maxContentOffset.height;

    [self _refreshPinchPoint];

}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_isPinching) {
        [self _refreshPinchPoint];
    }
}

- (void) _refreshPinchPoint {

    CGPoint corePoint = CGPointMake(10, self.view.height - TFNodeViewHeight - 10);
    CGPoint offset = _scrollView.contentOffset;
    _nodesController.pinchEndPoint = CGPointMake(corePoint.x + offset.x, corePoint.y + offset.y);

}


@end