//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageGridViewController.h"
#import "TFMindmapButtonsViewController.h"


@class TFImageGridViewController;
@class TFMindmapButtonsViewController;
@class TFPhoto;
@class Project;


@interface TFNewMindmapFullscreenViewController : UIViewController <TFImageGridViewControllerDelegate, TFMindmapButtonsViewControllerDelegate> {
    NSInteger selectedIndex;
}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, assign) NSArray *images;

@property(nonatomic, strong) TFImageGridViewController *imagesController;
@property(nonatomic, strong) TFMindmapButtonsViewController *buttonsController;
@property(nonatomic) NSInteger selectedIndex;
- (instancetype) initWithProject: (Project *) project images: (NSArray *) images;

@end