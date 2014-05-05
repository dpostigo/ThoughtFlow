//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


extern NSString * const TFToolbarProjectsNotification;


@interface ToolbarController : TFViewController <UIViewControllerTransitioningDelegate> {

    IBOutlet UIButton *notesButton;

    IBOutlet UIView *buttonsView;
    IBOutlet UIView *drawerView;

    UIViewController *toolbarDrawer;

}

@property(nonatomic, strong) NSArray *buttons;
@end