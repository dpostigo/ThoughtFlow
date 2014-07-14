//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewTutorialViewController.h"
#import "REPagedScrollView.h"
#import "UIView+DPKit.h"
#import "DRPaginatedScrollView.h"
#import "UIControl+BlocksKit.h"


@interface TFNewTutorialViewController ()

@property(nonatomic, strong) DRPaginatedScrollView *scrollView;
@end

@implementation TFNewTutorialViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    //    [self _setupIntroView];

    _scrollView = [DRPaginatedScrollView new];
    _scrollView.delegate = self;
    [_containerView embedView: _scrollView];

    [_scrollView addPageWithHandler: ^(UIView *pageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: pageView.bounds];
        imageView.backgroundColor = [UIColor redColor];
        [pageView embedView: imageView];
    }];

    [_scrollView addPageWithHandler: ^(UIView *pageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: pageView.bounds];
        imageView.backgroundColor = [UIColor blueColor];
        [pageView embedView: imageView];
    }];

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






#pragma mark - Refresh

- (void) _refreshPageControl {
    _pageControl.currentPage = _scrollView.currentPage;
}

#pragma mark - Setup

- (void) _setupIntroView {

    CGRect rect = self.view.bounds;

    CGRect pageRect = CGRectMake(0, 0, self.view.width, self.view.frame.size.height - 40);

    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame: self.view.bounds];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view embedView: scrollView];

    UIView *test = [[UIView alloc] initWithFrame: pageRect];
    test.backgroundColor = [UIColor lightGrayColor];
    [scrollView addPage: test];

    test = [[UIView alloc] initWithFrame: pageRect];
    test.backgroundColor = [UIColor blueColor];
    [scrollView addPage: test];

    test = [[UIView alloc] initWithFrame: pageRect];
    test.backgroundColor = [UIColor greenColor];
    [scrollView addPage: test];

    test = [[UIView alloc] initWithFrame: pageRect];
    test.backgroundColor = [UIColor redColor];
    [scrollView addPage: test];

    test = [[UIView alloc] initWithFrame: pageRect];
    test.backgroundColor = [UIColor yellowColor];
    [scrollView addPage: test];
}


@end