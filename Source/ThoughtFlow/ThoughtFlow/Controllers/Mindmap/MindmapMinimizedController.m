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
#import "UIButton+TFNodeView.h"

CGFloat const MindmapMinimizedX = 70;
CGFloat const MindmapMinimizedOffsetY = 10;

@implementation MindmapMinimizedController

- (void) viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton normalNodeButton];
    button.left = MindmapMinimizedX;
    button.bottom = 10;
    button.selected = YES;
    [button setTitle: _model.selectedNode.title forState: UIControlStateNormal];
    [self.view addSubview: button];

    [button updateSuperBottomConstraint: button.bottom];
    [button updateSuperLeadingConstraint: button.left];
    [self.view setNeedsUpdateConstraints];
    [button addTarget: self action: @selector(handleNodeDown:) forControlEvents: UIControlEventTouchUpInside];

}


- (void) handleNodeDown: (id) sender {
    [self.navigationController popViewControllerAnimated: NO];
}
@end