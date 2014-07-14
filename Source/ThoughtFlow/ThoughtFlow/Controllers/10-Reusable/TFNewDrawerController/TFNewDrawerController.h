//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


@class TFNewDrawerController;

@protocol TFNewDrawerControllerDelegate <NSObject>

- (void) drawerControllerShouldDismiss: (TFNewDrawerController *) drawerController;
@end


@interface TFNewDrawerController : TFViewController

@property(nonatomic, assign) id <TFNewDrawerControllerDelegate> drawerDelegate;
- (IBAction) closeDrawer: (id) sender;
- (void) _notifyDrawerControllerShouldDismiss;
@end