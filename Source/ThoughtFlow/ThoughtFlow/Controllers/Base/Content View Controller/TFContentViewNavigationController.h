//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFContentView.h"

@class TFContentView;
@class TFNewDrawerController;

@interface TFContentViewNavigationController : UINavigationController <TFContentViewDelegate>

@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) TFNewDrawerController *leftDrawerController;
@property(nonatomic, strong) TFNewDrawerController *rightDrawerController;
- (void) toggleViewController: (UIViewController *) controller animated: (BOOL) flag;
- (void) openLeftContainer;
- (void) openRightContainer;
@end