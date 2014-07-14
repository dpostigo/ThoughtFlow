//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Project;
@class TFEmptyViewController;
@class TFContentView;
@class TFContentViewNavigationController;
@class TFTranslucentView;
@class MVPopupTransition;


@interface TFNewMoodboardViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) TFContentViewNavigationController *contentNavigationController;

@property(nonatomic, strong) TFTranslucentView *bg;
@property(nonatomic, strong) MVPopupTransition *animator;
- (instancetype) initWithProject: (Project *) project;

@end