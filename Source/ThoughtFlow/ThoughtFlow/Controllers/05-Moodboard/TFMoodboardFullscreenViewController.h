//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMoodboardGridViewController.h"
#import "TFCornerButtonsViewController.h"


@class TFCornerButtonsViewController;


@interface TFMoodboardFullscreenViewController : TFMoodboardGridViewController <TFImageGridViewControllerDelegate, TFCornerButtonsViewControllerDelegate> {

}

@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) TFCornerButtonsViewController *buttonsController;
@end