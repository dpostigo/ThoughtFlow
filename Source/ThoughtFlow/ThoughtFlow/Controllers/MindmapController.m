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

@implementation MindmapController

@synthesize creationNode;

@synthesize pressGesture;

- (void) viewDidLoad {
    [super viewDidLoad];


    firstNodeView.text = _model.selectedProject.word;
    firstNodeView.delegate = self;

    firstNodeView.node = [self.currentProject.nodes firstObject];
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

    [self setupProject];

}


- (void) setupProject {

    NSArray *nodes = self.currentProject.nodes;
    for (int j = 0; j < [nodes count]; j++) {
        TFNode *node = [nodes objectAtIndex: j];

        TFNodeView *nodeView = [[TFNodeView alloc] init];
    }

    NSLog(@"[self.currentProject autoDescription] = %@", [self.currentProject autoDescription]);
    NSLog(@"self.currentProject.nodes = %@", self.currentProject.nodes);
    NSLog(@"[self.currentProject.items count] = %u", [self.currentProject.nodes count]);

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
    NSLog(@"_model.selectedNode = %@", _model.selectedNode);
    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];
}

- (void) nodeViewDidChangeState: (TFNodeView *) node {
    NSLog(@"%s, state = %d", __PRETTY_FUNCTION__, node.nodeState);

    if (node.nodeState == TFNodeViewStateCreate) {
        if ([node.gestureRecognizers count] == 0) {
            [node addGestureRecognizer: self.pressGesture];
        }

    } else {
        if ([node.gestureRecognizers containsObject: self.pressGesture]) {
            //            [node removeGestureRecognizer: self.pressGesture];
        }
    }

}


#pragma mark Nodes

- (void) addNode {

}

#pragma mark Gestures

- (void) nodeViewDidLongPress: (UILongPressGestureRecognizer *) gesture {

    TFNodeView *node = (TFNodeView *) gesture.view;

    CGPoint location = [gesture locationInView: self.view];

    //    [node removeGestureRecognizer: gesture];

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

    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        self.creationNode.center = location;

    } else if (gesture.state == UIGestureRecognizerStateEnded) {

        TFNode *projectNode = [[TFNode alloc] initWithTitle: @""];
        [_model.selectedProject addNode: projectNode];
        _model.selectedNode = projectNode;

        TFNodeView *newNodeView = [[TFNodeView alloc] initWithFrame: CGRectMake(0, 0,
                TFNodeViewWidth, TFNodeViewWidth)];
        newNodeView.node = projectNode;
        newNodeView.center = self.creationNode.center;
        [self.view addSubview: newNodeView];
        [_model.projectLibrary save];

        NSLog(@"newNodeView = %@", newNodeView);

        //        [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];
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

        [node removeGestureRecognizer: gesture];
    }

}


- (void) panNodeView: (UIPanGestureRecognizer *) gesture {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

#pragma mark Getters


- (Project *) currentProject {
    return _model.selectedProject;
}

- (UIView *) creationNode {
    if (creationNode == nil) {
        creationNode = [TFNodeView greenNode];
    }
    return creationNode;
}

- (UILongPressGestureRecognizer *) pressGesture {
    if (pressGesture == nil) {
        pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                     action: @selector(nodeViewDidLongPress:)];

        pressGesture.minimumPressDuration = 0.5;
    }
    return pressGesture;
}


@end