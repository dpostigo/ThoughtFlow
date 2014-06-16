//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MindmapMinimizedController.h"
#import "UIViewController+DPKit.h"
#import "UIViewController+TFControllers.h"

@implementation MindmapMinimizedController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self embedFullscreenController: self.mindmapBackgroundController];
    [self embedFullscreenController: self.minimizedLayerController];
}

@end