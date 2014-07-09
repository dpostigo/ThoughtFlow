//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNode;
@class Project;
@protocol TFNodesViewControllerDelegate;


extern CGFloat const TFMindmapMinimizedX;
extern CGFloat const TFMindmapMinimizedOffsetY;

@interface TFMinimizedNodesViewController : UIViewController {

}

@property(nonatomic, strong) id <TFNodesViewControllerDelegate> delegate;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) TFNode *node;
- (void) animateOut: (void (^)()) completion;
@end