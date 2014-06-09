//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFModalViewController.h"

@class NavigationFadeAnimator;

@interface PreloginContainerController : TFModalViewController {

    NavigationFadeAnimator *animator;
}

@property(nonatomic, strong) NavigationFadeAnimator *animator;
@end