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


@interface TFNewMoodboardViewController : UIViewController

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) TFEmptyViewController *emptyController;
@property(nonatomic, strong) TFContentViewNavigationController *contentNavigationController;

@property(nonatomic, strong) TFTranslucentView *bg;
- (instancetype) initWithProject: (Project *) project;

@end