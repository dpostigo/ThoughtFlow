//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMindmapCollectionViewController.h"


@class TFPhoto;
@class TFMindmapFullCollectionViewController;


@protocol TFMindmapFullCollectionViewControllerDelegate <NSObject>

- (void) mindmapCollectionViewController: (TFMindmapFullCollectionViewController *) controller selectedImage: (TFPhoto *) image;

@end


@interface TFMindmapFullCollectionViewController : TFMindmapCollectionViewController

@property(nonatomic, assign) id <TFMindmapFullCollectionViewControllerDelegate> delegate;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) NSIndexPath *initialIndexPath;
@property(nonatomic) BOOL isPinching;
@end