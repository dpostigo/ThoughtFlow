//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class ToolbarDrawerController;

@interface ToolbarController : TFViewController <UIViewControllerTransitioningDelegate> {

    ToolbarDrawerController *drawerController;
}

@property(nonatomic, strong) ToolbarDrawerController *drawerController;
@property(nonatomic, strong) NSArray *buttons;
@end