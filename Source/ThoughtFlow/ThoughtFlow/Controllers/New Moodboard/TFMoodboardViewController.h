//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Project;
@class TFContentViewNavigationController;
@class TFContentView;
@class TFEmptyViewController;

@interface TFMoodboardViewController : UIViewController {

}

@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFContentView *contentView;
@property(nonatomic, strong) TFContentViewNavigationController *contentNavigationController;

- (instancetype) initWithProject: (Project *) project;

@end