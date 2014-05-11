//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MindmapMinimizedController.h"
#import "TFNodeView.h"
#import "UIView+DPConstraints.h"
#import "Model.h"
#import "TFNode.h"

CGFloat const MindmapMinimizedX = 70;
CGFloat const MindmapMinimizedOffsetY = 10;

@implementation MindmapMinimizedController

- (void) viewDidLoad {
    [super viewDidLoad];

    cornerView = [[TFNodeView alloc] init];
    cornerView.left = MindmapMinimizedX;
    cornerView.bottom = 10;
    [self.view addSubview: cornerView];

    [cornerView updateSuperBottomConstraint: cornerView.bottom];
    [cornerView updateSuperLeadingConstraint: cornerView.left];
    [self.view setNeedsUpdateConstraints];

    cornerView.enabled = NO;
    cornerView.selected = YES;
    [cornerView.viewNormal addTarget: self action: @selector(handleNodeDown:) forControlEvents: UIControlEventTouchUpInside];

    cornerView.text = _model.selectedNode.title;
}


- (void) handleNodeDown: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.navigationController popViewControllerAnimated: YES];
}
@end