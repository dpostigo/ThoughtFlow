//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMindmapButtonsViewController.h"
#import "TFMindmapController.h"
#import "TFImageDrawerViewController.h"


@class Project;
@class TFNode;
@class TFMindmapButtonsViewController;
@class MindmapBackgroundController;
@class TFContentViewNavigationController;
@class TFMindmapGridViewController;
@class TFNewMindmapGridViewController;
@class TFMindmapFullscreenViewController;
@class NavigationFadeAnimator;
@class TFNewMindmapFullscreenViewController;
@class TFPhoto;
@class TFContentView;


@protocol TFMindmapImageControllerProtocol <NSObject>
- (void) imageController: (UIViewController *) controller didSelectImage: (TFPhoto *) image;
@end

@interface TFNewMindmapBackgroundViewController : UIViewController <TFMindmapButtonsViewControllerDelegate,
        UINavigationControllerDelegate,
        TFMindmapImageControllerProtocol,
        TFImageDrawerViewControllerDelegate>

@property(nonatomic) TFMindmapControllerType mindmapType;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, strong) TFNode *node;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, copy) NSString *imageString;
@property(nonatomic, strong) TFNewMindmapFullscreenViewController *fullscreenController2;
@property(nonatomic, strong) TFMindmapFullscreenViewController *fullscreenController;
@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) NavigationFadeAnimator *fadeAnimator;
- (instancetype) initWithProject: (Project *) project node: (TFNode *) node;

@end