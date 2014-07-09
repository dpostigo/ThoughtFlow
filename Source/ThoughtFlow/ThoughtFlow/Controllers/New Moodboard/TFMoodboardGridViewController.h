//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageGridViewController.h"


@class TFImageGridViewController;
@class Project;
@class TFEmptyViewController;


@interface TFMoodboardGridViewController : UIViewController <TFImageGridViewControllerDelegate> {

}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *currentImage;
@property(nonatomic, strong) TFEmptyViewController *emptyController;
@property(nonatomic, strong) TFImageGridViewController *imagesController;
- (instancetype) initWithProject: (Project *) project;

- (void) _setupControllers;
@end