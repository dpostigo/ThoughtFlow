//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MinimizedLayerController.h"
#import "TFNodeView.h"
#import "UIView+DPConstraints.h"
#import "Model.h"
#import "TFNode.h"
#import "UIButton+TFNodeView.h"

CGFloat const MindmapMinimizedX = 10;
CGFloat const MindmapMinimizedOffsetY = 10;

@implementation MinimizedLayerController

@synthesize nodeButton;

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    [self.view addSubview: self.nodeButton];
    nodeButton.left = MindmapMinimizedX;
    nodeButton.bottom = 10;
    nodeButton.selected = YES;
    [nodeButton setTitle: _model.selectedNode.title forState: UIControlStateNormal];

    [nodeButton updateSuperBottomConstraint: nodeButton.bottom];
    [nodeButton updateSuperLeadingConstraint: nodeButton.left];
    [self.view setNeedsUpdateConstraints];
    //    [nodeButton addTarget: self action: @selector(handleNodeDown:) forControlEvents: UIControlEventTouchUpInside];

}


- (void) handleNodeDown: (id) sender {
    [self.navigationController popViewControllerAnimated: NO];
}

- (UIButton *) nodeButton {
    if (nodeButton == nil) {
        nodeButton = nodeButton = [UIButton normalNodeButton];
    }
    return nodeButton;
}

@end