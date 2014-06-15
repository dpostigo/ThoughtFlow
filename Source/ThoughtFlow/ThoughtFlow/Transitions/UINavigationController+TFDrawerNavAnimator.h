//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFLeftDrawerNavAnimator;

@interface UINavigationController (TFDrawerNavAnimator)

- (void) popViewControllerWithAnimator: (TFLeftDrawerNavAnimator *) animator completion: (void (^)()) completion;
@end