//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFLinesViewController;
@class TFNodesViewController;
@class Project;
@class TFNodeScrollView;


@interface TFPanningNodesViewController : UIViewController {

    TFLinesViewController *_linesController;
    TFNodesViewController *_nodesController;
    TFNodeScrollView *_scrollView;
}

@property(nonatomic, strong) Project *project;
- (instancetype) initWithProject: (Project *) project;

@end