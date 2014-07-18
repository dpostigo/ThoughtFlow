//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewTutorialViewController.h"
#import "UIView+DPKit.h"
#import "DRPaginatedScrollView.h"
#import "UIControl+BlocksKit.h"
#import "UIView+DPKitDebug.h"


@interface TFNewTutorialViewController ()

@property(nonatomic, strong) DRPaginatedScrollView *scrollView;
@end

@implementation TFNewTutorialViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.opaque = NO;

    _scrollView = [DRPaginatedScrollView new];
    _scrollView.delegate = self;
    [_containerView embedView: _scrollView];

    NSArray *images = @[
            [[UIImageView alloc] initWithFrame: self.view.bounds],
            [[UIImageView alloc] initWithFrame: self.view.bounds],
            [[UIImageView alloc] initWithFrame: self.view.bounds],
            [[UIImageView alloc] initWithFrame: self.view.bounds],
            [[UIImageView alloc] initWithFrame: self.view.bounds]
    ];

    int count = 5;

    for (int j = 0; j < 5; j++) {
        [_scrollView addPageWithHandler: ^(UIView *pageView) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: pageView.bounds];
            imageView.backgroundColor = [UIColor clearColor];
            [imageView addDebugBorder: [UIColor lightGrayColor]];
            [pageView embedView: imageView];
        }];
    }

    _pageControl.numberOfPages = _scrollView.numberOfPages;
    [_pageControl bk_addEventHandler: ^(id sender) {
        UIPageControl *pageControl = sender;
        [_scrollView jumpToPage: pageControl.currentPage bounce: 0.125 completion: nil];

    } forControlEvents: UIControlEventValueChanged];
}



#pragma mark - Delegate
#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView {
    [self _refreshPageControl];
}


- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView {

    [UIView animateWithDuration: 0.4 animations: ^{
        _swipeLabel.alpha = _pageControl.currentPage == 0 ? 1 : 0;
    }];

}





#pragma mark - Refresh

- (void) _refreshPageControl {
    _pageControl.currentPage = _scrollView.currentPage;

}

#pragma mark - Setup


@end