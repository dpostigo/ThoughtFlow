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
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "MindmapController+NodeUtils.h"
#import "PanningView.h"
#import "TFNodeView+Utils.h"
#import "MindmapController+LineDrawing.h"
#import "MindmapController+UIPinch.h"
#import "MindmapBackgroundController.h"
#import "TFRightDrawerAnimator.h"
#import "UIViewController+TFControllers.h"
#import "UIViewController+BasicModalAnimator.h"

@implementation MindmapController {
    TFNodeViewState lastNodeState;
    TFRightDrawerAnimator *rightDrawerAnimator;
}

@synthesize creationNode;
@synthesize nodeViews;

- (void) viewDidLoad {
    [super viewDidLoad];

    [CATransaction setAnimationDuration: 5.0];

    nodeContainerView = (PanningView *) firstNodeView.superview;
    nodeContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    backgroundController = [self.storyboard instantiateViewControllerWithIdentifier: @"MindmapBackgroundController"];
    [nodeContainerView addSubview: backgroundController.view];
    [self addChildViewController: backgroundController];
    [nodeContainerView sendSubviewToBack: backgroundController.view];
    backgroundController.view.frame = self.view.bounds;
    backgroundController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [backgroundController.view updateSuperEdgeConstraints: 0];

    lineView = [[UIView alloc] initWithFrame: nodeContainerView.bounds];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [nodeContainerView insertSubview: lineView belowSubview: firstNodeView];
    [lineView updateSuperEdgeConstraints: 0];
    lineView.userInteractionEnabled = NO;

    firstNodeView.nodeState = TFNodeViewStateNormal;

    [self setupProjectNodes];
    [self.view setNeedsUpdateConstraints];
    [self redrawLines];

    [self setupGestures];

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    if (isPinched) {
        [self unpinch];
    }
}


#pragma mark Setup


- (void) setupProjectNodes {
    NSArray *nodes = self.currentProject.nodes;

    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = [nodes objectAtIndex: j];
        TFNodeView *nodeView = nil;

        if (j == 0) {
            nodeView = firstNodeView;
            [nodeContainerView addSubview: nodeView];

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

    [self updateLastNode];

}


- (void) setupGestures {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoublePan:)];
    recognizer.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer: recognizer];

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinch:)];
    [self.view addGestureRecognizer: pinch];
}


#pragma mark Pinch

- (void) handlePinch: (UIPinchGestureRecognizer *) gesture {
    TFNodeView *node = self.selectedNode;
    if (node == nil)
        return;

    [node.superview bringSubviewToFront: node];

    NSLog(@"gesture.scale = %f", gesture.scale);
    CGFloat newScale = fmaxf(0, (gesture.scale - 0.3) / 0.7);
    newScale = 1 - newScale;

    switch (gesture.state) {

        case UIGestureRecognizerStateBegan :
            [self startPinchWithScale: newScale];
            break;

        case UIGestureRecognizerStateChanged : {
            if (gesture.scale < 1) {
                [self updatePinchWithScale: newScale];
            }
        }
            break;

        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateFailed :
        case UIGestureRecognizerStateCancelled :
            [self endPinchWithScale: newScale];
            break;
    }
}

#pragma mark Two-finger Pan

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

        [self assignDelegate: self];
        [self redrawLines];
        [self assignDelegate: nil];

    }

}

- (void) startDoublePanWithPoint: (CGPoint) point secondPoint: (CGPoint) point2 {

}




#pragma mark TFNodeViewDelegate

- (void) nodeViewDidDoubleTap: (TFNodeView *) node {
    _model.selectedNode = node.node;
    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];
}

- (void) nodeViewDidChangeState: (TFNodeView *) node {

}

- (void) nodeViewDidChangeSelection: (TFNodeView *) node {
    _model.selectedNode = node.node;
    [self deselectOtherNodes: node];

}


- (void) nodeViewDidTriggerDeletion: (TFNodeView *) node {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSUInteger index = [self.nodeViews indexOfObject: node];

    [_model.selectedProject removeItem: node.node];
    [[lineView.layer.sublayers objectAtIndex: index] removeFromSuperlayer];
    [self.nodeViews removeObject: node];

    [self redrawLines];
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
                [self updateLastNode];
            }];

}


- (void) nodeViewDidTriggerRelated: (TFNodeView *) node {
    _model.selectedNode = node.node;
    [self performSegueWithIdentifier: @"RelatedSegue" sender: nil];

}



#pragma mark Node Interaction

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    TFNodeView *node = (TFNodeView *) gesture.view;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastNodeState = node.nodeState;
    }

    switch (lastNodeState) {
        case TFNodeViewStateNormal :
            NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
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

    NSLog(@"%s", __PRETTY_FUNCTION__);
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



#pragma mark IBActions

- (IBAction) handleGridButton: (UIButton *) sender {
    //    [[NSNotificationCenter defaultCenter] postNotificationName: TFNavigationNotification
    //                                                        object: nil
    //                                                      userInfo: @{
    //                                                              TFViewControllerTypeName : @"MoodboardController",
    //                                                              TFViewControllerTypeKey : [NSNumber numberWithInteger: TFControllerMoodboard]
    //                                                      }];

    //    [self postNavigationNotificationForType: TFControllerMoodboard];

}

- (IBAction) handleInfoButton: (UIButton *) sender {
    rightDrawerAnimator = [TFRightDrawerAnimator new];
    [self.navigationController presentController: self.imageDrawerController withAnimator: rightDrawerAnimator];

}

- (IBAction) handlePinButton: (UIButton *) sender {

}


@end