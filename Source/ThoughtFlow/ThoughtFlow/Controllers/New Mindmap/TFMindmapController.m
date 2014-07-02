//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import "TFMindmapController.h"
#import "MindmapButtonsController.h"
#import "MindmapBackgroundController.h"
#import "UIViewController+TFControllers.h"
#import "UIViewController+DPKit.h"
#import "Project.h"
#import "TFNodeView.h"
#import "TFNode.h"
#import "MindmapLinesController.h"
#import "UIView+DPKit.h"
#import "Model.h"

@implementation TFMindmapController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setup];
    [self _setupChildControllers];
    [self _setupProject];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (_project.modifiedDate == nil) {

        TFNodeView *nodeView = _nodesController.nodeViews[0];
        nodeView.node.position = nodeView.origin;
        _project.modifiedDate = [NSDate date];
        [_project save];
    }

}



#pragma mark - Setup

- (void) _setup {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

- (void) _setupChildControllers {

    _backgroundController = (MindmapBackgroundController *) self.mindmapBackgroundController;
    [self embedFullscreenController: _backgroundController];

    _linesController = [[MindmapLinesController alloc] init];
    [self embedFullscreenController: _linesController];

    _nodesController = [[TFNodesViewController alloc] init];
    _nodesController.delegate = self;
    [self embedFullscreenController: _nodesController];

    MindmapButtonsController *buttonsController = (MindmapButtonsController *) self.mindmapButtonsController;
    //    buttonsController.drawerPresenter = self;
    [self embedFullscreenController: buttonsController];

    NSLog(@"self.navigationController = %@", self.navigationController);



    //    _backgroundController.imageString = _model.selectedProject.word;
}


- (void) _setupProject {
    if (_project) {
        _nodesController.nodes = _project.flattenedChildren;
        //        _linesController.nodes = _project.nodes;

        if (_project.modifiedDate == nil) {
            [_nodesController centerFirstNode];
        }
    }
}


#pragma mark - TFNodesViewDelegate



- (void) nodesControllerDidUpdateViews: (NSArray *) nodeViews {
    _linesController.rootNode = _project.firstNode;
    _linesController.tempLayer.hidden = YES;

}


#pragma mark - Moving

- (void) nodesControllerDidBeginMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    [_linesController targetNode: node];
}

- (void) nodesControllerDidUpdateMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    //    _linesController.rootNode = _project.firstNode;
    [_linesController updateTargetNode: node withNodeView: nodeView];
}


- (void) nodesControllerDidEndMovingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {

    node.position = nodeView.origin;
    [_project save];

    _linesController.rootNode = _project.firstNode;
    [_linesController endTargetNode];
}


#pragma mark - Creation

- (void) nodesControllerDidBeginCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    [_linesController updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
    _linesController.tempLayer.hidden = NO;
}

- (void) nodesControllerDidUpdateCreatingNodeView: (TFNodeView *) nodeView withParent: (TFNodeView *) parentNodeView {
    [_linesController updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
}


- (void) nodesControllerDidEndCreatingNodeView: (TFNodeView *) nodeView forNode: (TFNode *) node {
    node.title = @"I'm a test node";
    //    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];

}


- (void) nodesControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode {
    [rootNode.mutableChildren addObject: node];
    [self _refreshNodes];

}


#pragma mark - Updation


- (void) nodesControllerDidDoubleTapNode: (TFNode *) node {

    _model.selectedNode = node;
    [self performSegueWithIdentifier: @"EditModalSegue" sender: nil];

}


#pragma mark - TFEditNodeControllerDelegate

- (void) editNodeController: (TFEditNodeController *) controller dismissedWithName: (NSString *) name {
    if (_model.selectedNode) {

        TFNode *node = _model.selectedNode;
        __block TFNodeView *nodeView;
        NSUInteger index = [_project.flattenedChildren indexOfObject: node];
        _model.selectedNode.title = name;

        nodeView = [_nodesController.nodeViews objectAtIndex: index];

        [UIView animateWithDuration: 0.4 animations: ^{
            nodeView.alpha = 0;
        } completion: ^(BOOL finished) {
            [self _refreshNodes];
            nodeView = [_nodesController.nodeViews objectAtIndex: index];

            [UIView animateWithDuration: 0.4 animations: ^{

                nodeView.alpha = 1;
            }];
        }];

    }
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

        if ([segue.destinationViewController isKindOfClass: [TFEditNodeController class]]) {
            TFEditNodeController *editNodeController = segue.destinationViewController;
            editNodeController.delegate = self;

        }
        if ([segue.identifier isEqualToString: @"RelatedSegue"]) {
            customSegue.modalSize = CGSizeMake(815, 650);
            //            destinationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        }
    }
}




//
//
//#pragma mark - Lazy initializers
//
//- (TFNodesViewController *) nodesController {
//    if (_nodesController == nil) {
//        _nodesController = [[TFNodesViewController alloc] init];
//        [self embedFullscreenController: _nodesController];
//    }
//    return _nodesController;
//}
//
//- (MindmapBackgroundController *) backgroundController {
//    if (_backgroundController == nil) {
//        _backgroundController = (MindmapBackgroundController *) self.mindmapBackgroundController;
//        [self embedFullscreenController: _backgroundController];
//    }
//    return _backgroundController;
//}


#pragma mark - Utils

- (void) _refreshNodes {
    _nodesController.nodes = _project.flattenedChildren;
}

@end