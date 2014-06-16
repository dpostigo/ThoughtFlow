//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFDrawerController;

@protocol TFDrawerPresenter <NSObject>

@required
- (void) presentDrawerController: (TFDrawerController *) controller;
- (void) dismissDrawerController: (TFDrawerController *) controller;
@end