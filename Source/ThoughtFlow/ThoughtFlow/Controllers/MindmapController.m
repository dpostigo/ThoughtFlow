//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "MindmapController.h"
#import "TFNodeView.h"
#import "Model.h"
#import "Project.h"
#import "CustomModalSegue.h"
#import "TFNode.h"
#import "ProjectLibrary.h"
#import "TFConstants.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "MindmapController+NodeUtils.h"
#import "PanningView.h"
#import "TFNodeView+Utils.h"

@implementation MindmapController {
    TFNodeViewState lastNodeState;
}

@synthesize creationNode;
@synthesize nodeViews;

- (void) viewDidLoad {
    [super viewDidLoad];

    [CATransaction setAnimationDuration: 5.0];

    nodeContainerView = (PanningView *) firstNodeView.superview;
    nodeContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    //    nodeContainerView.backgroundColor = [UIColor blueColor];

    lineView = [[UIView alloc] initWithFrame: nodeContainerView.bounds];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    //    lineView.backgroundColor = [UIColor redColor];
    [nodeContainerView insertSubview: lineView belowSubview: firstNodeView];
    [lineView updateSuperEdgeConstraints: 0];

    firstNodeView.nodeState = TFNodeViewStateNormal;

    [self setupNotifications];
    [self setupProjectNodes];
    [self.view setNeedsUpdateConstraints];
    [self setupLineDrawing];

    [self setupGestures];

}

#pragma mark Setup

- (void) setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarProjectsNotification
                                                      object: nil
                                                       queue: nil
                                                  usingBlock: ^(NSNotification *notification) {

                                                      [_model.projectLibrary save];

                                                      if (self.presentedViewController) {
                                                          [self dismissViewControllerAnimated: YES
                                                                                   completion: nil];
                                                      }
                                                      [self.navigationController popViewControllerAnimated: YES];
                                                  }];

}

- (void) setupProjectNodes {
    NSArray *nodes = self.currentProject.nodes;

    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = [nodes objectAtIndex: j];
        TFNodeView *nodeView = nil;

        if (j == 0) {
            nodeView = firstNodeView;
            if ([nodes count] == 1) {
                node.position = nodeView.origin;
            } else {
                nodeView.left = node.position.x;
                nodeView.top = node.position.y;
                [nodeView updateSuperTopConstraint: node.position.y];
                [nodeView updateSuperLeadingConstraint: node.position.x];
            }
        } else {
            nodeView = [[TFNodeView alloc] init];
            nodeView.left = node.position.x;
            nodeView.top = node.position.y;
            [nodeView updateSuperTopConstraint: node.position.y];
            [nodeView updateSuperLeadingConstraint: node.position.x];
        }

        nodeView.node = node;
        [self setupNodeView: nodeView];

    }
}


- (void) setupLineDrawing {
    if ([self.nodeViews count] > 1) {
        for (int j = 1; j < [self.nodeViews count]; j++) {
            [self drawLineForIndex: j];
        }
    }

}

- (void) setupGestures {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoublePan:)];
    recognizer.minimumNumberOfTouches = 2;

    [self.view addGestureRecognizer: recognizer];
}

- (void) handleDoublePan: (UIPanGestureRecognizer *) gesture {

    if (gesture.numberOfTouches > 1) {
        CGPoint translation = [gesture translationInView: gesture.view.superview];

        CGPoint startPoint;

        switch (gesture.state) {
            case UIGestureRecognizerStateBegan :
                nodeContainerView.startingPoint = nodeContainerView.frame.origin;
                break;
            case UIGestureRecognizerStateChanged :
                startPoint = nodeContainerView.startingPoint;

                CGPoint newPoint = CGPointMake(startPoint.x + translation.x, startPoint.y + translation.y);

                [nodeContainerView updateSuperLeadingConstraint: newPoint.x];
                [nodeContainerView updateSuperTopConstraint: newPoint.y];

                if (newPoint.x < 0) {
                    [nodeContainerView updateSuperWidthConstraint: -newPoint.x];
                }

                if (newPoint.y < 0) {
                    [nodeContainerView updateSuperHeightConstraint: -newPoint.y];
                }

                break;

            default :
                break;
        }
    }

    if (gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateFailed ||
            gesture.state == UIGestureRecognizerStateCancelled) {

        NSLog(@"nodeContainerView.origin = %@", NSStringFromCGPoint(nodeContainerView.origin));

        CGPoint offset = nodeContainerView.origin;
        if (nodeContainerView.left > 0) {
            [nodeContainerView updateSuperWidthConstraint: nodeContainerView.left];
        }
        if (nodeContainerView.top > 0) {
            [nodeContainerView updateSuperHeightConstraint: nodeContainerView.top];
        }

        for (TFNodeView *node in self.nodeViews) {
            CGPoint nodePoint = CGPointMake(node.left + offset.x, node.top + offset.y);
            [node updateSuperLeadingConstraint: nodePoint.x];
            [node updateSuperTopConstraint: nodePoint.y];
            node.node.position = nodePoint;
        }

        //        [lineView updateSuperLeadingConstraint: lineView.left - offset.x];
        //        [lineView updateSuperTopConstraint: lineView.top - offset.y];

        [nodeContainerView updateSuperTopConstraint: 0];
        [nodeContainerView updateSuperLeadingConstraint: 0];
        [nodeContainerView setNeedsUpdateConstraints];
        [nodeContainerView layoutIfNeeded];

        [lineView.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
            layer.delegate = self;
        }];

        [self setupLineDrawing];
        [lineView.layer.sublayers enumerateObjectsUsingBlock: ^(CALayer *layer, NSUInteger idx, BOOL *stop) {
            layer.delegate = self;
        }];

    }

}

- (void) startDoublePanWithPoint: (CGPoint) point secondPoint: (CGPoint) point2 {

}

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void) drawLineForIndex: (int) j {
    if (j < [self.nodeViews count]) {
        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];

        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        [self setLayerLine: layer fromPoint: nodeView.center toPoint: previousView.center];

        //        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        //        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];
        //        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        //        [self setLayerLine: layer
        //                 fromPoint: CGPointMake(nodeView.node.position.x + TFNodeViewWidth,
        //                         nodeView.node.position.y + TFNodeViewHeight)
        //                   toPoint: CGPointMake(
        //                           previousView.node.position.x + TFNodeViewWidth,
        //                           previousView.node.position.y + TFNodeViewHeight)];

        //        TFNode *node = [[self.nodeViews objectAtIndex: j] node];
        //        TFNode *previousNode = [[self.nodeViews objectAtIndex: j - 1] node];
        //        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        //        [self setLayerLine: layer
        //                 fromPoint: CGPointMake(node.position.x + TFNodeViewWidth,
        //                         node.position.y + TFNodeViewHeight)
        //                   toPoint: CGPointMake(
        //                           previousNode.position.x + TFNodeViewWidth,
        //                           previousNode.position.y + TFNodeViewHeight)];
    }
}





#pragma mark TFNodeViewDelegate

- (void) nodeViewDidDoubleTap: (TFNodeView *) node {
    _model.selectedNode = node.node;
    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];
}

- (void) nodeViewDidChangeState: (TFNodeView *) node {

}

- (void) nodeViewDidChangeSelection: (TFNodeView *) node {
    [self selectNode: node];

}


- (void) nodeViewDidTriggerDeletion: (TFNodeView *) node {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSUInteger index = [self.nodeViews indexOfObject: node];

    [_model.selectedProject removeItem: node.node];
    [[lineView.layer.sublayers objectAtIndex: index] removeFromSuperlayer];
    [self.nodeViews removeObject: node];

    [self setupLineDrawing];
    [UIView animateWithDuration: 1.0 delay: 0.0
         usingSpringWithDamping: 0.9f
          initialSpringVelocity: -1.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations: ^{

                         node.top = self.view.height + node.height;
                         node.alpha = 0;
                         //                         node.transform = CGAffineTransformMakeScale(0, 0);
                     }
                     completion: ^(BOOL completion) {
                         [node removeFromSuperview];
                     }];

}


- (void) nodeViewDidTriggerRelated: (TFNodeView *) node {

    _model.selectedNode = node.node;
    [self performSegueWithIdentifier: @"RelatedSegue" sender: nil];

}



#pragma mark Node Interaction

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastNodeState = node.nodeState;
    }

    switch (lastNodeState) {
        case TFNodeViewStateNormal :
            [self moveNodeViewWithGesture: gesture];
            break;

        case TFNodeViewStateCreate :
            [self createNodeViewWithLongPress: gesture];
            break;

        default :
            NSLog(@"[TFNodeView stringForNodeState: lastNodeState] = %@",
                    [TFNodeView stringForNodeState: lastNodeState]);
            break;
    }
}

- (void) moveNodeViewWithGesture: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: node.superview];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            [self startNodeMove: node location: location];
            break;

        case UIGestureRecognizerStateChanged :
            [self updateNodeMove: node location: location];
            break;

        case UIGestureRecognizerStateEnded :
            [self endNodeMove: node location: location];
            break;

        default :
            break;
    }
}


- (void) createNodeViewWithLongPress: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: nodeContainerView];
    currentNodeView = node;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            [self startCreateNodeFromNode: node location: location];
            break;

        case UIGestureRecognizerStateChanged :
            [self updateCreateNodeAtLocation: location];
            break;

        case UIGestureRecognizerStateEnded :
            [self endCreateNode];
            break;

        default :
            break;
    }

}



#pragma mark Nodes

- (void) addNode {

}





#pragma mark Getters


- (Project *) currentProject {
    return _model.selectedProject;
}

- (UIView *) creationNode {
    if (creationNode == nil) {
        creationNode = [TFNodeView greenGhostView];
    }
    return creationNode;
}


- (NSMutableArray *) nodeViews {
    if (nodeViews == nil) {
        nodeViews = [[NSMutableArray alloc] init];
    }
    return nodeViews;
}


#pragma mark CALayerDelegate


- (id <CAAction>) actionForLayer: (CALayer *) layer forKey: (NSString *) event {
    return (id) [NSNull null]; // disable all implicit animations
}

#pragma mark Custom modal

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    if ([segue isKindOfClass: [CustomModalSegue class]]) {
        CustomModalSegue *customSegue = (CustomModalSegue *) segue;
        customSegue.modalSize = CGSizeMake(340, 340);

        UIViewController *destinationController = segue.destinationViewController;
        destinationController.modalPresentationStyle = UIModalPresentationFormSheet;
        destinationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        if ([segue.identifier isEqualToString: @"RelatedSegue"]) {
            customSegue.modalSize = CGSizeMake(815, 650);
            //            destinationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        }

    }
}

#pragma mark Utils





@end