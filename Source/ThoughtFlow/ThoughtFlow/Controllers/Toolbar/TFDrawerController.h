//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFModalViewController.h"

@protocol TFDrawerPresenter;

@interface TFDrawerController : TFViewController {

    __unsafe_unretained id <TFDrawerPresenter> presenter;
    UITapGestureRecognizer *recognizer;
}

@property(nonatomic, assign) id <TFDrawerPresenter> presenter;
- (void) handleTap: (UITapGestureRecognizer *) recognizer;
- (IBAction) closeDrawer: (id) sender;
@end