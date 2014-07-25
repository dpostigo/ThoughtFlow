//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFContentView;
@class TFNode;


@interface TFMindmapBackgroundCollectionViewController : UIViewController <UINavigationControllerDelegate>

@property(nonatomic, strong) TFNode *node;
@property(nonatomic, strong) TFContentView *contentView;
- (instancetype) initWithContentView: (TFContentView *) contentView;

@end