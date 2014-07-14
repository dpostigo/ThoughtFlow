//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import "ViewController2.h"
#import "SampleNodeView.h"


@implementation ViewController2

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];

    _innerView = [[SampleNodeView alloc] initWithFrame: _scrollView.bounds];
    _innerView.backgroundColor = [UIColor whiteColor];
    [_scrollView embedView: _innerView];

    _widthConstraint = [NSLayoutConstraint constraintWithItem: _innerView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 2000];
    _heightConstraint = [NSLayoutConstraint constraintWithItem: _innerView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 2000];

    [_scrollView addConstraints: @[
            _widthConstraint,
            _heightConstraint
    ]];

    _scrollView.delegate = self;

    _scrollView.minimumZoomScale = 1.0;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.zoomScale = 1.0;
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView {

    CGPoint offset = scrollView.contentOffset;
    offset.x += scrollView.width;

    if (offset.x >= _innerView.width) {
        CGFloat currentWidth = _innerView.width;
        _widthConstraint.constant = currentWidth + (1/_scrollView.zoomScale);
    }

    else if (offset.y >= _innerView.height) {
        CGFloat currentHeight = _innerView.width;
        _heightConstraint.constant = currentHeight + (1/_scrollView.zoomScale);
    }

}

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView {
    return _innerView;
}


@end