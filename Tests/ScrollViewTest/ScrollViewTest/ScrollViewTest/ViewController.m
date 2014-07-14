//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ViewController.h"
#import "SampleNodeView.h"
#import "UIView+DPKit.h"
#import "TFNodeScrollViewContainer.h"
#import "TFNodeScrollView.h"
#import "UIView+DPConstraints.h"


@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    //    _container = [[TFNodeScrollViewContainer alloc] initWithFrame: _scrollView.bounds];

    //    [_container embedView: _innerView];

    //    [_scrollView addSubview: _container];
    _scrollView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: 0.3];
    [_scrollView setContentSize: CGSizeMake(self.view.width * 2, self.view.height * 2)];
    _scrollView.delegate = self;

    _innerView = [[SampleNodeView alloc] initWithFrame: _scrollView.bounds];
    [_scrollView addSubview: _innerView];
    //    [_scrollView.contentView embedView: _innerView];
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView {

    //    [_scrollView recenterIfNecessary];

    CGPoint offset = scrollView.contentOffset;
    NSLog(@"offset = %@", NSStringFromCGPoint(offset));

}


@end