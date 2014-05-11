//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class ToolbarController;
@class CustomModalAnimator;

@interface MainAppController : TFViewController {

    BOOL showsPrelogin;
    ToolbarController *toolbarController;
    IBOutlet UIViewController *contentController;
    CustomModalAnimator *animator;
    UINavigationController *navController;

}

@end