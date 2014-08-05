//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFCollectionViewController.h"
#import "TFNode.h"


@class TFNewMindmapLayout;


@interface TFMindmapCollectionViewController : TFCollectionViewController

@property(nonatomic, strong) TFNode *node;
- (void) setNode: (TFNode *) node images: (NSArray *) images;
- (TFNewMindmapLayout *) fullscreenLayout;
@end