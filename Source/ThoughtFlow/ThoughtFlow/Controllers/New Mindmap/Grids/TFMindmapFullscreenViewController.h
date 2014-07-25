//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TWTToast/TWTTransitionController.h>
#import "TFNewMindmapGridViewController.h"


@interface TFMindmapFullscreenViewController : TFNewMindmapGridViewController <TWTTransitionControllerDelegate>


@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@end