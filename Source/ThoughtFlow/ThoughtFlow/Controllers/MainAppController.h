//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFToolbarDelegate.h"

@class TFToolbarController;
@class CustomModalAnimator;
@class NavigationFadeAnimator;
@class ModalDrawerAnimator;
@class NavigationModalAnimator;
@class TFRightDrawerAnimator;
@class TFLeftDrawerAnimator;
@class ModalChildDrawerAnimator;

@interface MainAppController : TFViewController <TFToolbarDelegate> {

    BOOL showsPrelogin;

    TFToolbarController *toolbarController;
    UINavigationController *navController;
    IBOutlet UIViewController *contentController;

    CustomModalAnimator *animator;

    NavigationFadeAnimator *navigationAnimator;
    ModalDrawerAnimator *testAnimator;
    TFRightDrawerAnimator *rightDrawerAnimator;
    TFLeftDrawerAnimator *leftDrawerAnimator;
    ModalChildDrawerAnimator *childDrawerAnimator;
}

@end