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
@class TFLeftDrawerNavAnimator;
@class TFDrawerNavAnimator;
@class TFDrawerModalAnimator;

@interface MainAppController : TFViewController <TFToolbarDelegate, UINavigationControllerDelegate> {

    BOOL showsPrelogin;

    TFToolbarController *toolbarController;
    UINavigationController *navController;
    IBOutlet UIViewController *contentController;

    CustomModalAnimator *animator;

    NavigationFadeAnimator *navigationAnimator;
    TFDrawerModalAnimator *testAnimator;
    TFRightDrawerAnimator *rightDrawerAnimator;
    TFLeftDrawerAnimator *leftDrawerAnimator;
    ModalChildDrawerAnimator *childDrawerAnimator;
    TFDrawerNavAnimator *navAnimator;
    TFDrawerNavAnimator *rightNavAnimator;
}

@end