//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DRPaginatedScrollView;


@interface TFNewTutorialViewController : UIViewController <UIScrollViewDelegate>

@property(weak) IBOutlet UIView *containerView;
@property(weak) IBOutlet UIPageControl *pageControl;
@end