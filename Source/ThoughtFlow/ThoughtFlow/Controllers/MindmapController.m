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

@implementation MindmapController {
    TFNodeViewState lastNodeState;
}

@synthesize creationNode;

@synthesize pressGesture;

@synthesize nodeViews;

- (void) viewDidLoad {
    [super viewDidLoad];

    lineView = [[UIView alloc] initWithFrame: self.view.bounds];
    lineView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    lineView.hidden = YES;
    [self.view insertSubview: lineView belowSubview: firstNodeView.superview];

    firstNodeView.nodeState = TFNodeViewStateNormal;

    [[NSNotificationCenter defaultCenter] addObserverForName: TFToolbarProjectsNotification
                                                      object: nil
                                                       queue: nil
                                                  usingBlock: ^(NSNotification *notification) {

                                                      if (self.presentedViewController) {
                                                          NSLog(@"Mind map Has presented view controller.");
                                                          [self dismissViewControllerAnimated: YES
                                                                                   completion: nil];
                                                      }
                                                      [self.navigationController popViewControllerAnimated: YES];
                                                  }];

    [self.nodeViews addObject: firstNodeView];
    [self setupProjectNodes];
    [self setupGestures];

}


- (void) setupProjectNodes {
    NSArray *nodes = self.currentProject.nodes;
    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = [nodes objectAtIndex: j];

        if (j == 0) {
            NSLog(@"node.position = %@", NSStringFromCGPoint(node.position));
            firstNodeView.delegate = self;
            firstNodeView.node = node;
            [firstNodeView updateSuperLeadingConstraint: node.position.x];
            [firstNodeView updateSuperTopConstraint: node.position.y];
        } else {
            TFNodeView *nodeView = [[TFNodeView alloc] init];
            nodeView.node = node;
            nodeView.delegate = self;
            [firstNodeView.superview addSubview: nodeView];
        }

        CALayer *sublayer = [CALayer new];
        sublayer.hidden = YES;
        [lineView.layer addSublayer: sublayer];

    }

}

- (void) setupGestures {

    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                                          action: @selector(nodeViewDidLongPress:)];
    gesture.minimumPressDuration = 0.25;
    [firstNodeView addGestureRecognizer: gesture];
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





#pragma mark Nodes

- (void) addNode {

}

#pragma mark Gestures

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {
    TFNodeView *node = (TFNodeView *) gesture.view;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastNodeState = node.nodeState;
    }

    NSLog(@"[node stringForNodeState: lastNodeState] = %@", [node stringForNodeState: lastNodeState]);
    if (lastNodeState == TFNodeViewStateNormal) {
        [self moveNodeViewWithLongPress: gesture];

    } else if (lastNodeState == TFNodeViewStateCreate) {
        [self createNodeViewWithLongPress: gesture];
    }

}

- (void) moveNodeViewWithLongPress: (UILongPressGestureRecognizer *) gesture {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: node.superview];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat springVelocity = (-0.1 * 30.0) / (node.frame.origin.x - location.x);

        [UIView animateWithDuration: 0.4 delay: 0.0
             usingSpringWithDamping: 0.9f
              initialSpringVelocity: springVelocity
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             node.center = location;
                             //                             node.transform = CGAffineTransformMakeScale(1.1, 1.1);
                         }
                         completion: ^(BOOL finished) {
                         }];

    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        node.center = location;

    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        location = CGPointMake(location.x - (node.width / 2), location.y - (node.height / 2));
        [node updateSuperLeadingConstraint: location.x];
        [node updateSuperTopConstraint: location.y];
        node.node.position = location;
        [self.view setNeedsUpdateConstraints];

        [UIView animateWithDuration: 0.4
                         animations: ^{
                             [self.view layoutIfNeeded];
                             //                             node.transform = CGAffineTransformIdentity;
                         }
                         completion: ^(BOOL finished) {
                             //                             [node updateSuperLeadingConstraint: location.x];
                             //                             [node updateSuperTopConstraint: location.y];
                         }];

    }
}

- (void) createNodeViewWithLongPress: (UILongPressGestureRecognizer *) gesture {

    TFNodeView *node = (TFNodeView *) gesture.view;
    CGPoint location = [gesture locationInView: self.view];
    currentNodeView = node;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIView *newNode = self.creationNode;
        newNode.center = location;
        newNode.alpha = 0;
        newNode.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [self.view addSubview: newNode];
        [node setNodeState: TFNodeViewStateNormal animated: YES];

        [UIView animateWithDuration: 0.4 animations: ^{
            newNode.alpha = 0.8;
            newNode.transform = CGAffineTransformIdentity;
        }];

        [self showLineView];
        setLayerToLineFromAToB(lineView.layer, self.creationNode.center, currentNodeView.center, 1);

    } else if (gesture.state == UIGestureRecognizerStateChanged) {

        CGFloat distance = DistanceBetweenTwoPoints(self.creationNode.center, currentNodeView.center);
        self.creationNode.alpha = fmaxf(distance / 200, 1);
        self.creationNode.center = location;
        setLayerToLineFromAToB(lineView.layer, self.creationNode.center, currentNodeView.center, 1);

    } else if (gesture.state == UIGestureRecognizerStateEnded) {

        TFNode *projectNode = [[TFNode alloc] initWithTitle: @""];
        [_model.selectedProject addNode: projectNode];
        _model.selectedNode = projectNode;

        TFNodeView *newNodeView = [[TFNodeView alloc] initWithFrame: CGRectMake(0, 0,
                TFNodeViewWidth, TFNodeViewWidth)];
        newNodeView.node = projectNode;
        newNodeView.delegate = self;
        newNodeView.center = self.creationNode.center;
        [self.view addSubview: newNodeView];
        [self.nodeViews addObject: newNodeView];
        [self selectNode: newNodeView];

        [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];

        [UIView animateWithDuration: 0.4
                         animations: ^{
                             self.creationNode.alpha = 0;
                             //                             self.creationNode.backgroundColor = [UIColor whiteColor];
                         }
                         completion: ^(BOOL finished) {
                             if (self.creationNode.superview) {
                                 [self.creationNode removeFromSuperview];
                             }
                         }];

        //        [node removeGestureRecognizer: gesture];
    }

}

- (void) panNodeView: (UIPanGestureRecognizer *) gesture {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void) showLineView {
    lineView.hidden = NO;
}

- (void) updateLineViews: (TFNodeView *) nodeView {
}


- (void) selectNode: (TFNodeView *) nodeView {
    NSArray *nodes = [self.view childrenOfClass: [TFNodeView class]];
    for (TFNodeView *node in nodes) {
        if (node != nodeView) {
            node.selected = NO;
        }
    }
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


#pragma mark Utils


void setLayerToLineFromAToB(CALayer *layer, CGPoint a, CGPoint b, CGFloat lineWidth) {
    CGPoint center = {0.5 * (a.x + b.x), 0.5 * (a.y + b.y)};
    CGFloat length = sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = atan2(a.y - b.y, a.x - b.x);

    layer.position = center;
    layer.bounds = (CGRect) {{0, 0}, {length + lineWidth, lineWidth}};
    layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

CGFloat DistanceBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx * dx + dy * dy);
};


@end