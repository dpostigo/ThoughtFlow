//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "MindmapController+NodePositioning.h"
#import "TFNodeView+Utils.h"
#import "TFNode.h"
#import "UIView+DPConstraints.h"

@implementation MindmapController (NodePositioning)

- (void) resetNodeLocations {
    for (TFNodeView *nodeView in self.nodeViews) {
        nodeView.left = nodeView.node.position.x;
        nodeView.top = nodeView.node.position.y;
        [nodeView updateSuperTopConstraint: nodeView.node.position.y];
        [nodeView updateSuperLeadingConstraint: nodeView.node.position.x];
    }
}




- (void) resetNodeConstraints {
    for (TFNodeView *nodeView in self.nodeViews) {
        [nodeView updateSuperTopConstraint: nodeView.node.position.y];
        [nodeView updateSuperLeadingConstraint: nodeView.node.position.x];
    }

}
@end