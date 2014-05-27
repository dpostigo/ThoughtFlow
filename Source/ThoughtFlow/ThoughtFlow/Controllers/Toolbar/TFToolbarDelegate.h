//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFToolbarController.h"

@protocol TFToolbarDelegate <NSObject>

@optional

- (void) toolbarChangeSelection: (BOOL) selected forType: (TFToolbarButtonType) type;
- (void) toolbarDidSelectButtonWithType: (NSNumber *) type;
- (void) toolbarDidDeselectButtonWithType: (NSNumber *) type;

@end