//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class ToolbarController;

@interface MainMapController : TFViewController <UIViewControllerTransitioningDelegate> {

    ToolbarController *toolbarController;
    IBOutlet  UIViewController *contentController;
}
@end