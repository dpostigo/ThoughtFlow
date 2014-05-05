//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

typedef enum {
    TFToolbarModeDefault = 0,
    TFToolbarModeMindmap = 1
} TFToolbarMode;

@interface ToolbarController : TFViewController <UIViewControllerTransitioningDelegate> {

    IBOutlet UIView *buttonsView;
    IBOutlet UIView *drawerView;

    UIViewController *toolbarDrawer;

    TFToolbarMode toolbarMode;

}

@property(nonatomic, strong) NSArray *buttons;
@property(nonatomic) TFToolbarMode toolbarMode;

@property(weak) IBOutlet UIButton *notesButton;
@property(weak) IBOutlet UIButton *moodButton;
@end