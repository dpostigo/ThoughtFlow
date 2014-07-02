//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNewToolbarController.h"

@class TFNewToolbarController;
@class NavigationSlideAnimator;
@class TFContentNavigationController;
@class TFContentView;
@class NavigationFadeAnimator;

@interface NewMainAppController : TFViewController <TFNewToolbarControllerDelegate, UINavigationControllerDelegate> {

}

@property(weak) IBOutlet TFContentView *contentView;
@property(nonatomic, strong) TFNewToolbarController *toolbarController;
@property(nonatomic, strong) TFContentNavigationController *contentNavigationController;

@property(nonatomic, strong) NavigationFadeAnimator *fadingNavigationAnimator;
@property(nonatomic, strong) NavigationSlideAnimator *slidingNavigationAnimator;

@end