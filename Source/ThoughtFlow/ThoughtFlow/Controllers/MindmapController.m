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
#import "ToolbarController.h"
#import "ProjectLibrary.h"
#import "NSObject+AutoDescription.h"
#import "TFConstants.h"
#import "TFNodeStateView.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKitChildren.h"
#import "UIView+DPKit.h"
#import "MindmapController+NodeUtils.h"

@implementation MindmapController {
    TFNodeViewState lastNodeState;
}

@synthesize creationNode;

@synthesize pressGesture;

@synthesize nodeViews;

- (void) viewDidLoad {
    [super viewDidLoad];

    [CATransaction setAnimationDuration: 5.0];

    nodeContainerView = firstNodeView.superview;
    nodeContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    lineView = [[UIView alloc] initWithFrame: self.view.bounds];
    //    lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    //    lineView.hidden = YES;
    [self.view insertSubview: lineView belowSubview: nodeContainerView];

    firstNodeView.nodeState = TFNodeViewStateNormal;

    [self setupNotifications];

    [self setupProjectNodes];
    [self.view setNeedsUpdateConstraints];
    [self setupLineDrawing];

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


- (void) drawLineForIndex: (int) j {
    if (j < [self.nodeViews count]) {
        TFNodeView *nodeView = [self.nodeViews objectAtIndex: j];
        TFNodeView *previousView = [self.nodeViews objectAtIndex: j - 1];

        CALayer *layer = [lineView.layer.sublayers objectAtIndex: j];
        [self setLayerLine: layer fromPoint: nodeView.center toPoint: previousView.center];

    }

}





#pragma mark TFNodeViewDelegate

- (void) nodeViewDidDoubleTap: (TFNodeView *) node {
    _model.selectedNode = node.node;
    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];
}

- (void) nodeViewDidChangeState: (TFNodeView *) node {
    //    NSLog(@"%s, state = %d", __PRETTY_FUNCTION__, node.nodeState);

    //    currentNodeView = node;

    //
    //    if (node.nodeState == TFNodeViewStateCreate) {
    //        if ([node.gestureRecognizers count] == 0) {
    //            [node addGestureRecognizer: self.pressGesture];
    //            NSLog(@"Added gesture.");
    //
    //        }
    //
    //    } else {
    //        if ([node.gestureRecognizers containsObject: self.pressGesture]) {
    //            //            [node removeGestureRecognizer: self.pressGesture];
    //        }
    //    }

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
    CGPoint location = [gesture locationInView: self.view];
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

- (UILongPressGestureRecognizer *) pressGesture {
    if (pressGesture == nil) {
        pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                     action: @selector(nodeViewDidLongPress:)];

        pressGesture.minimumPressDuration = 0.25;
    }
    return pressGesture;
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