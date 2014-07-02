//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageGridViewController.h"


@class TFMindmapGridViewController;
@class TFPhoto;

@protocol TFMindmapGridViewControllerDelegate <NSObject>

- (void) mindmapGridViewController: (TFMindmapGridViewController *) controller clickedButtonForImage: (TFPhoto *) image;
@end;

@class TFImageGridViewController;
@class TFEmptyViewController;


@interface TFMindmapGridViewController : UIViewController <TFImageGridViewControllerDelegate>

@property(nonatomic, copy) NSString *imageString;
@property(nonatomic, assign) id <TFMindmapGridViewControllerDelegate> delegate;
@property(nonatomic, strong) TFEmptyViewController *emptyController;
@property(nonatomic, strong) TFImageGridViewController *imagesController;

- (instancetype) initWithImageString: (NSString *) imageString;
+ (instancetype) controllerWithImageString: (NSString *) imageString;


@end