//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFScrollingMindmapViewController.h"
#import "TFNodesViewController.h"
#import "TFLinesViewController.h"
#import "UIView+DPKit.h"
#import "UIViewController+DPKit.h"
#import "DPPassThroughView.h"
#import "TFScrollView.h"
#import "TFScrollViewContentView.h"
#import "UIView+DPKitDebug.h"
#import "TFNodeView.h"


@interface TFScrollingMindmapViewController ()

@property(nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic, strong) UIView *mindmapView;
@property(nonatomic, strong) TFScrollView *scrollView;
@property(nonatomic) CGPoint startingOffset;
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
    //    _heightConstraint.constant = self.view.height + _maxContentOffset.height;
    //    _heightConstraint.constant = self.view.height + _maxContentOffset.height;

    [self.view layoutIfNeeded];

    //    [_nodesController.view addDebugBorder: [UIColor yellowColor]];

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

    if (maximumPoint.x > _maximumPoint.x ||
            maximumPoint.y > _maximumPoint.y) {

        _maximumPoint = maximumPoint;

        CGPoint contentOffset = _scrollView.contentOffset;
        CGPoint newOffset = CGPointMake(contentOffset.x + 1, contentOffset.y + 1);

        //    newOffset.x -= 10;
        //    newOffset.y -= TFNodeViewHeight;

        _scrollView.contentOffset = newOffset;

    } else {
        NSLog(@"Stop.");

    }

    return;

    //    maximumPoint = CGPointMake(fmaxf(maximumPoint.x, _maximumPoint.x), fmaxf(maximumPoint.y, _maximumPoint.y));


    //    maximumPoint = CGPointMake(fmaxf(maximumPoint.x, _maximumPoint.x), fmaxf(maximumPoint.y, _maximumPoint.y));

    //    maximumPoint.x += 50;
    //    maximumPoint.y += 50;


    maximumPoint = CGPointMake(fmaxf(maximumPoint.x, self.view.width), fmaxf(maximumPoint.y, self.view.height));

    _maximumPoint = maximumPoint;

    NSLog(@"_maximumPoint = %@", NSStringFromCGPoint(_maximumPoint));
    CGSize extra = CGSizeMake(_maximumPoint.x - self.view.width, _maximumPoint.y - self.view.height);

    NSLog(@"extra = %@", NSStringFromCGSize(extra));
    CGPoint contentOffset = _scrollView.contentOffset;

    CGPoint newOffset = CGPointMake(contentOffset.x + extra.width, contentOffset.y + extra.height);

    //    newOffset.x -= 10;
    //    newOffset.y -= TFNodeViewHeight;

    _scrollView.contentOffset = newOffset;

    //    self.maxContentOffset = extra;

    //    [self.view layoutIfNeeded];



    //
    //    //    CGFloat maxX = fminf(_maximumPoint.x - self.view.width, self.view.width);
    //    //    CGFloat maxY = fminf(_maximumPoint.y - self.view.height, self.view.width);
    //
    //    NSLog(@"extra = %@", NSStringFromCGSize(extra));
    //    //    CGFloat width = fmaxf(_maximumPoint.x, self.view.width + _maxContentOffset.width) - self.view.width;
    //    //    CGFloat height = fmaxf(_maximumPoint.y, self.view.height) - self.view.height;
    //    //
    //    //    //    NSLog(@"width = %f", width);
    //    //    CGSize offset = CGSizeMake(width, height);
    //    //
    //    //    NSLog(@"extra = %@, offset = %@", NSStringFromCGSize(extra), NSStringFromCGSize(offset));
    //
    //

    //    CGPoint newOffset = CGPointMake(contentOffset.x - extra.width, contentOffset.y - extra.height);
    //    _scrollView.contentOffset = newOffset;


    //    _maxContentOffset = extra;
    //    _widthConstraint.constant = self.view.width + _maxContentOffset.width;
    //    _heightConstraint.constant = self.view.height + _maxContentOffset.height;
    //
    //    [UIView animateWithDuration: 0.4 animations: ^{
    //
    //        [self.view layoutIfNeeded];
    //    } completion: ^(BOOL finished) {
    //
    //        _scrollView.contentOffset = contentOffset;
    //
    //    }];


    //
    //    self.maxContentOffset = extra;
    //
    //    if (_scrollView.contentOffset.x > contentOffset.x) {
    //
    //        NSLog(@"contentOffset = %@", NSStringFromCGPoint(contentOffset));
    //        NSLog(@"_scrollView.contentOffset = %@", NSStringFromCGPoint(_scrollView.contentOffset));
    //
    //    }

    //    _scrollView.contentOffset = contentOffset;
}



#pragma mark - Public, Pinch

- (void) startPinchWithScale: (CGFloat) scale {
    [_nodesController startPinchWithScale: scale];
}

- (void) updatePinchWithScale: (CGFloat) scale {
    [_nodesController updatePinchWithScale: scale];
}


- (void) endPinchWithScale: (CGFloat) scale {
    [_nodesController endPinchWithScale: scale];
}


#pragma mark - Public, Pan

- (void) startPan: (UIPanGestureRecognizer *) recognizer {
    _startingOffset = _scrollView.contentOffset;

}

- (void) updatePan: (UIPanGestureRecognizer *) recognizer {
    CGPoint translation = [recognizer translationInView: recognizer.view];
    CGPoint currentOffset = _scrollView.contentOffset;
    translation = CGPointMake(_startingOffset.x - translation.x, _startingOffset.y - translation.y);

    _scrollView.contentOffset = translation;

    //    self.maxContentOffset = CGSizeMake(fmaxf(0, translation.x), fmaxf(0, translation.y));
    self.maxContentOffset = CGSizeMake(translation.x, translation.y);

}

- (void) endPan: (UIPanGestureRecognizer *) recognizer {
    CGPoint offset = _scrollView.contentOffset;
    self.maxContentOffset = CGSizeMake(offset.x, offset.y);
}


- (void) endNodeMove {

    CGPoint offset = _scrollView.contentOffset;
    self.maxContentOffset = CGSizeMake(offset.x, offset.y);
}

#pragma mark - Delegates
#pragma mark - UIScrollView



- (void) scrollViewDidScroll: (UIScrollView *) scrollView {

    //    CGPoint startingOffset = scrollView.contentOffset;
    //    startingOffset.x += scrollView.width;
    //
    //    CGFloat limitX = self.view.width + TFScrollingMindmapWidthLimit;
    //    CGFloat limitY = self.view.height + TFScrollingMindmapHeightLimit;
    //    //    NSLog(@"startingOffset = %@, limitX = %f", NSStringFromCGPoint(startingOffset), limitX);
    //
    //    if (startingOffset.x >= _mindmapView.width && startingOffset.x < self.view.width + TFScrollingMindmapWidthLimit) {
    //
    //        CGFloat currentWidth = _mindmapView.width;
    //        _widthConstraint.constant = currentWidth + (1 / _scrollView.zoomScale);
    //        //        _widthConstraint.constant = currentWidth + 1;
    //    }
    //
    //    else if (startingOffset.y >= _mindmapView.height && startingOffset.y < self.view.height + TFScrollingMindmapHeightLimit) {
    //        CGFloat currentHeight = _mindmapView.width;
    //        _heightConstraint.constant = currentHeight + (1 / _scrollView.zoomScale);
    //        //        _heightConstraint.constant = currentHeight + 1;
    //    }
}




#pragma mark - Setup

- (void) _setup {

    _linesController = [[TFLinesViewController alloc] init];
    _nodesController = [[TFNodesViewController alloc] init];

    [self _setupScrollView];
    [self _setupMindmapView];
    [self _setupControllers];

    //    [_mindmapView addDebugBorder: [UIColor yellowColor]];
    //    [_nodesController.view addDebugBorder: [UIColor redColor]];

    NSLog(@"_mindmapView.height = %f", _mindmapView.height);

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
    //    _mindmapView = [[DPPassThroughView alloc] initWithFrame: self.view.bounds];
    //    _mindmapView = [[TFScrollViewContentView alloc] initWithFrame: self.view.bounds];
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

}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGPoint corePoint = CGPointMake(10, self.view.height - TFNodeViewHeight - 10);
    //    CGPoint convertedPoint = [self.view convertPoint: corePoint toView: _nodesController.view];
    //    CGPoint convertedPoint = [_nodesController.view convertPoint: corePoint fromView: self.view];
    CGPoint convertedPoint = [self.view convertPoint: corePoint fromView: _nodesController.view];
    CGPoint convertedPoint3 = [self.view convertPoint: corePoint toView: _nodesController.view];
    CGPoint convertedPoint2 = [_nodesController.view convertPoint: corePoint fromView: self.view];
    CGPoint convertedPoint4 = [_nodesController.view convertPoint: corePoint toView: self.view];

    CGPoint offset = _scrollView.contentOffset;
    NSLog(@"offset = %@", NSStringFromCGPoint(offset));
    _nodesController.pinchEndPoint = corePoint;
}


@end