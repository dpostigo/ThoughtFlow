//
// Created by Dani Postigo on 7/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"
#import "TFTableViewController.h"


@class TFPhoto;
@class TFNewImageDrawerViewController;

@protocol TFNewImageDrawerViewControllerDelegate <NSObject>

- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController removedPin: (TFPhoto *) image;
- (void) imageDrawerViewController: (TFNewImageDrawerViewController *) imagesController addedPin: (TFPhoto *) image;

@end;


@class Project;
@class TFPhoto;
@protocol TFImageDrawerViewControllerDelegate;


@interface TFNewImageDrawerViewController : TFNewDrawerController <TFTableViewControllerDelegate> {

    NSArray *_rows;
}

@property(nonatomic, strong) TFPhoto *image;
@property(nonatomic, strong) Project *project;
@property(nonatomic, assign) id <TFNewImageDrawerViewControllerDelegate> delegate;

@property(weak) IBOutlet UILabel *titleLabel;
@property(weak) IBOutlet UIButton *pinButton;
@property(weak) IBOutlet UIView *containerView;

- (instancetype) initWithProject: (Project *) project image: (TFPhoto *) image;


@end