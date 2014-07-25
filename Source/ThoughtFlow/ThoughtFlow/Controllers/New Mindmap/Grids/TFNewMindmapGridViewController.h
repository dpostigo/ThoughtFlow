//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFImageGridViewController.h"
#import "TFMindmapViewController.h"


@class Project;
@class TFImageGridViewController;
@class TFEmptyViewController;
@class TFPhoto;
@protocol TFMindmapImageControllerProtocol;


@interface TFNewMindmapGridViewController : UIViewController <TFImageGridViewControllerDelegate>

@property(nonatomic) BOOL isMinimized;
@property(nonatomic) TFMindmapControllerType mindmapType;
@property(nonatomic, readonly) UICollectionView *collectionView;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) TFImageGridViewController *imagesController;
@property(nonatomic, assign) id <TFMindmapImageControllerProtocol> delegate;
- (instancetype) initWithProject: (Project *) project images: (NSArray *) images;


- (void) reloadVisibleItems;
- (void) _setup;
- (void) _setupControllers;
- (void) _notifySelection: (TFPhoto *) image;
@end