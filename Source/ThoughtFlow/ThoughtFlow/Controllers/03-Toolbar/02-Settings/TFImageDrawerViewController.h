//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"


@class TFPhoto;
@class Project;
@class TFImageDrawerContentViewController;
@class TFImageDrawerViewController;

@protocol TFImageDrawerViewControllerDelegate <NSObject>

- (void) imageDrawerViewController: (TFImageDrawerViewController *) imagesController removedPin: (TFPhoto *) image;
- (void) imageDrawerViewController: (TFImageDrawerViewController *) imagesController addedPin: (TFPhoto *) image;

@end;

@interface TFImageDrawerViewController : TFNewDrawerController

@property(nonatomic, assign) id <TFImageDrawerViewControllerDelegate> delegate;
@property(nonatomic, strong) TFImageDrawerContentViewController *contentViewController;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *image;


@property(weak) IBOutlet UIButton *pinButton;
@property(weak) IBOutlet UILabel *titleLabel;

- (instancetype) initWithProject: (Project *) project image: (TFPhoto *) image;


@end