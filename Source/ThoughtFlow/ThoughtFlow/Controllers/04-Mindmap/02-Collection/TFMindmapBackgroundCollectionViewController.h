//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFMindmapButtonsViewController.h"
#import "TFNewImageDrawerViewController.h"
#import "TFMindmapFullCollectionViewController.h"


@class TFContentView;
@class TFNode;


@interface TFMindmapBackgroundCollectionViewController : UIViewController <UINavigationControllerDelegate,
        TFMindmapButtonsViewControllerDelegate, TFNewImageDrawerViewControllerDelegate, TFMindmapFullCollectionViewControllerDelegate>

@property(nonatomic, strong) TFNode *node;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) TFContentView *contentView;
- (instancetype) initWithContentView: (TFContentView *) contentView;
- (instancetype) initWithContentView: (TFContentView *) contentView project: (Project *) project node: (TFNode *) node;


@end