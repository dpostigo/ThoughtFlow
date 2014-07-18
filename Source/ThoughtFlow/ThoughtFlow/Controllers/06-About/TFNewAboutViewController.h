//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"


@class TFTranslucentView;


@interface TFNewAboutViewController : TFNewDrawerController

@property(weak) IBOutlet UIView *tutorialContainerView;
@property(weak) IBOutlet UIView *labelContainerView;
@property(weak) IBOutlet UIButton *closeButton;
@property(weak) IBOutlet UILabel *moodboardLabel;
@property(weak) IBOutlet UILabel *notesLabel;
@property(weak) IBOutlet UILabel *imageSearchLabel;
@end