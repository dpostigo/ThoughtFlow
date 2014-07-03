//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@class TFRightDrawerAnimator;
@protocol TFToolbarDelegate;

typedef enum {
    TFToolbarModeDefault = 0,
    TFToolbarModeMindmap = 1
} TFToolbarMode;


typedef enum {
    TFToolbarButtonNone = 0,
    TFToolbarButtonProjects = 1,
    TFToolbarButtonNotes = 2,
    TFToolbarButtonMoodboard = 3,
    TFToolbarButtonAccount = 4,
    TFToolbarButtonSettings = 5,
    TFToolbarButtonInfo = 6

} TFToolbarButtonType;

