//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFToolbarViewController.h"
#import "TFNewAccountViewController.h"


@class TFToolbarViewController;
@class NavigationSlideAnimator;
@class TFContentViewNavigationController;
@class TFContentView;
@class NavigationFadeAnimator;

@interface NewMainAppController : TFViewController <TFToolbarViewControllerDelegate,
        UINavigationControllerDelegate,
        TFNewAccountViewControllerDelegate> {

}

@property(weak) IBOutlet TFContentView *contentView;
@property(nonatomic, strong) TFToolbarViewController *toolbarController;
@property(nonatomic, strong) TFContentViewNavigationController *contentNavigationController;

@property(nonatomic, strong) NavigationFadeAnimator *fadingNavigationAnimator;
@property(nonatomic, strong) NavigationSlideAnimator *slidingNavigationAnimator;

@end