//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPTransitions/CustomModalSegue.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import "TFMindmapController.h"
#import "UIViewController+DPKit.h"
#import "Project.h"
#import "TFNodeView.h"
#import "TFNode.h"
#import "TFLinesViewController.h"
#import "UIView+DPKit.h"
#import "Model.h"
#import "TFContentViewNavigationController.h"
#import "TFPhoto.h"
#import "TFNewMindmapBackgroundViewController.h"
#import "TFMindmapRelatedViewController.h"
#import "TFMinimizedNodesViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIView+DPKitDebug.h"
#import "TFPanningNodesViewController.h"
#import "TFScrollingMindmapViewController.h"


@interface TFMindmapController ()

@property(nonatomic) CGPoint startingPoint;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@property(nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property(nonatomic, strong) TFNewMindmapBackgroundViewController *bgController;
@property(nonatomic, strong) TFLinesViewController *linesController;
@property(nonatomic, strong) TFNodesViewController *nodesController;
@property(nonatomic, strong) TFMinimizedNodesViewController *minimizedController;
@end

@implementation TFMindmapController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    TFMindmapController *ret = [[UIStoryboard storyboardWithName: @"Mindmap" bundle: nil] instantiateViewControllerWithIdentifier: @"TFMindmapController"];
    return ret;
}


- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
    }

    return self;
}


#pragma mark - View lifecycle

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

}


- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
    [self.view removeGestureRecognizer: _pinchRecognizer];
    [self.view removeGestureRecognizer: _panRecognizer];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    if (_project.modifiedDate == nil) {
        TFBaseNodeView *nodeView = _nodesController.nodeViews[0];
        nodeView.node.position = nodeView.origin;
        _project.modifiedDate = [NSDate date];
        [_project save];
    }

    [_nodesController selectFirstNodeView];

}


- (void) viewDidLoad {
    [super viewDidLoad];

    if ([self.view isKindOfClass: [TFContentView class]]) {
        _contentView = (TFContentView *) self.view;
    }

    [self _setup];

}



#pragma mark - Setup

- (void) _setup {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    [self _setupChildControllers];
    [self _setupProject];
    [self _setupGestureRecognizers];

}

- (void) _setupChildControllers {

    _bgController = [[TFNewMindmapBackgroundViewController alloc] initWithProject: _project node: _project.firstNode];
    _bgController.contentView = _contentView;
    [self embedFullscreenController: _bgController];

    _scrollingController = [[TFScrollingMindmapViewController alloc] init];
    [self embedFullscreenController: _scrollingController];

    _linesController = _scrollingController.linesController;

    _nodesController = _scrollingController.nodesController;
    _nodesController.delegate = self;



    //
    //
    //    _scrollView = [[UIScrollView alloc] initWithFrame: self.view.bounds];
    //    [self embedFullscreenView: _scrollView];
    //
    //    _mindmapView = [[UIView alloc] initWithFrame: self.view.bounds];
    //    [_scrollView embedView: _mindmapView];
    //    _widthConstraint = [NSLayoutConstraint constraintWithItem: _mindmapView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 2000];
    //    _heightConstraint = [NSLayoutConstraint constraintWithItem: _mindmapView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: 2000];
    //    [_scrollView addConstraints: @[
    //            _widthConstraint,
    //            _heightConstraint
    //    ]];
    //
    //    _linesController = [[TFLinesViewController alloc] init];
    //    [_mindmapView embedController: _linesController];
    //
    //    _nodesController = [[TFNodesViewController alloc] init];
    //    _nodesController.delegate = self;
    //    [_mindmapView embedController: _nodesController];
    //
    //    _scrollView.delegate = self;
    //    _scrollView.minimumZoomScale = 1.0;
    //    _scrollView.maximumZoomScale = 2.0;
    //    _scrollView.zoomScale = 1.0;

    //    _linesController = [[TFLinesViewController alloc] init];
    //    [self embedFullscreenController: _linesController];
    //
    //    _nodesController = [[TFNodesViewController alloc] init];
    //    _nodesController.delegate = self;
    //    [self embedFullscreenController: _nodesController];

}


- (void) scrollViewDidScroll: (UIScrollView *) scrollView {

    CGPoint offset = scrollView.contentOffset;
    offset.x += scrollView.width;

    if (offset.x >= _mindmapView.width) {
        CGFloat currentWidth = _mindmapView.width;
        _widthConstraint.constant = currentWidth + (1 / _scrollView.zoomScale);
    }

    else if (offset.y >= _mindmapView.height) {
        CGFloat currentHeight = _mindmapView.width;
        _heightConstraint.constant = currentHeight + (1 / _scrollView.zoomScale);
    }
}

- (void) _setupProject {
    if (_project) {

        [self _refreshNodes];

        if (_project.modifiedDate == nil) {
            [_nodesController centerFirstNode];
        }

        _panningController = [[TFPanningNodesViewController alloc] initWithProject: _project];
    }
}


- (void) _setupGestureRecognizers {
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget: self action: @selector(handlePinch:)];
    [self.view addGestureRecognizer: _pinchRecognizer];

    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoublePan:)];
    _panRecognizer.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer: _panRecognizer];
}



#pragma mark - Delegates



#pragma mark - TFMindmapGridViewControllerDelegate

- (void) mindmapGridViewController: (TFMindmapGridViewController *) controller clickedButtonForImage: (TFPhoto *) image {
    [_project addPin: image];
    [_project save];
    [controller reloadImage: image];

}


#pragma mark - TFNodesViewControllerDelegate

- (void) nodesControllerDidUpdateViews: (NSArray *) nodeViews {
    _linesController.rootNode = _project.firstNode;

}


#pragma mark - TFNodesViewControllerDelegate, Moving

- (void) nodesControllerDidBeginMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    [_linesController startTargetNode: node];
}

- (void) nodesControllerDidUpdateMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    //    _linesController.rootNode = _project.firstNode;
    [_linesController updateTargetNode: node withNodeView: nodeView];

    CGPoint rightEdge = [self maxRightEdgeInNode: _nodesController.nodeViews];

    //    NSLog(@"rightEdge = %@", NSStringFromCGPoint(rightEdge));
    //    _scrollingController.maximumPoint = rightEdge;

}


- (CGPoint) maxRightEdgeInNode: (NSArray *) nodes {
    CGFloat maxX = 0;
    CGFloat maxY = 0;

    for (int j = 0; j < [nodes count]; j++) {
        TFBaseNodeView *nodeView = nodes[j];

        if (nodeView.right > maxX) {
            maxX = nodeView.right;
        }
        if (nodeView.bottom > maxY) {
            maxY = nodeView.bottom;
        }
    }

    return CGPointMake(maxX, maxY);
}

- (void) nodesControllerDidEndMovingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {

    node.position = nodeView.origin;
    [_project save];

    _linesController.rootNode = _project.firstNode;
    [_linesController endTargetNode];
}


#pragma mark - TFNodesViewControllerDelegate, Creation

- (void) nodesControllerDidBeginCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    [_linesController startMoveWithNodeView: nodeView withParent: parentNodeView];
}

- (void) nodesControllerDidUpdateCreatingNodeView: (TFBaseNodeView *) nodeView withParent: (TFBaseNodeView *) parentNodeView {
    [_linesController updateTempLineFromPoint: nodeView.center toPoint: parentNodeView.center];
}


- (void) nodesControllerDidEndCreatingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    node.title = @"node";
    [_linesController endMoveWithNodeView: nil withParent: nil];

}


- (void) nodesControllerDidCreateNode: (TFNode *) node withRoot: (TFNode *) rootNode {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [rootNode.mutableChildren addObject: node];
    [self _refreshNodes];

    [_project save];

}


#pragma mark - TFNodesViewControllerDelegate, Updation


- (void) nodesControllerDidDoubleTapNode: (TFNode *) node {
    _model.selectedNode = node;

    TFNewEditNodeController *controller = [[TFNewEditNodeController alloc] initWithNode: node];
    controller.delegate = self;
    //    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    //    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController: controller animated: YES completion: nil];

    //    controller.view.superview.frame = self.view.bounds;
    //    controller.view.superview.backgroundColor = [UIColor clearColor];
    //    controller.view.superview.opaque = NO;

}

- (void) nodesControllerDidTapRelated: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    _model.selectedNode = node;

    TFMindmapRelatedViewController *controller = [[TFMindmapRelatedViewController alloc] initWithNode: _model.selectedNode];
    controller.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController: controller animated: YES completion: ^() {

    }];
    CGRect rect = CGRectMake(0, 0, 815, 650);
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - rect.size.width) / 2;
    rect.origin.y = ([UIScreen mainScreen].bounds.size.height - rect.size.height) / 2;
    controller.view.superview.frame = rect;
    controller.view.superview.backgroundColor = [UIColor clearColor];
    controller.view.superview.opaque = NO;

    //    [self.navigationController pushViewController: controller animated: YES];

}


- (void) nodesControllerDidDeleteNode: (TFNode *) node {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (node == _project.firstNode) {
        [UIAlertView showWithTitle: @"Delete Node"
                message: @"You can't delete the first word of your project."
                cancelButtonTitle: @"OK"
                otherButtonTitles: nil
                tapBlock: nil];

    } else {

        NSLog(@"[_project.flattenedChildren count] = %u", [_project.flattenedChildren count]);

        if ([node.children count] > 0) {
            NSArray *children = node.children;
            if (node.parentNode) {
                TFNode *parentNode = node.parentNode;
                [parentNode addChildren: children];
            }
            //            if (node.parentNode.parentNode) {
            //                [node.parentNode.parentNode addChild: node];
            //            }

        }

        [node.parentNode removeChild: node];

        NSLog(@"[_project.flattenedChildren count] = %u", [_project.flattenedChildren count]);

        [self _refreshNodes];
    }

}


#pragma mark - TFNodesViewControllerDelegate Pinch


- (void) nodesControllerDidBeginPinchingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    [_linesController startPinchWithNodeViews: _nodesController.nodeViews];

}

- (void) nodesControllerDidUpdatePinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    [_linesController updatePinchWithNodeViews: _nodesController.nodeViews];
    //    [self _refreshLines];

}


- (void) nodesControllerDidEndPinchingNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    [_linesController endPinchWithNodeViews: _nodesController.nodeViews];

}


- (void) nodesControllerDidCompletePinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {
    _bgController.mindmapType = TFMindmapControllerTypeMinimized;

    _minimizedController = [[TFMinimizedNodesViewController alloc] init];
    _minimizedController.delegate = self;
    [self embedFullscreenController: _minimizedController];

    _nodesController.view.hidden = YES;
    _linesController.view.hidden = YES;

}


- (void) nodesControllerDidUnpinchWithNodeView: (TFBaseNodeView *) nodeView forNode: (TFNode *) node {

    [_minimizedController animateOut: ^{

        _nodesController.view.hidden = NO;
        _linesController.view.hidden = NO;
        [self unembedController: _minimizedController];
        [_nodesController unpinch];

    }];

}


#pragma mark - Selection

- (void) nodesControllerDidSelectNode: (TFNode *) node {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _selectedNode = node;
    _bgController.node = _selectedNode;

}




#pragma mark - TFEditNodeControllerDelegate


- (void) editNodeController: (TFNewEditNodeController *) controller didEditNode: (TFNode *) node withName: (NSString *) name {

    __block TFBaseNodeView *nodeView;
    NSUInteger index = [_project.flattenedChildren indexOfObject: node];
    _model.selectedNode.title = name;
    nodeView = [_nodesController.nodeViews objectAtIndex: index];

    [self _refreshNodes];

    nodeView = [_nodesController.nodeViews objectAtIndex: index];
    [_nodesController selectNodeView: nodeView];

    [UIView animateWithDuration: 0.4 animations: ^{
        //            nodeView.alpha = 1;
    }];

    //        [UIView animateWithDuration: 0.4 animations: ^{
    //            nodeView.alpha = 0;
    //        } completion: ^(BOOL finished) {
    //
    //        }];

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




#pragma mark - Double pan

- (void) handleDoublePan: (UIPanGestureRecognizer *) gesture {
    CGPoint translation = [gesture translationInView: gesture.view];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan : {
            [_scrollingController startPan: gesture];
        }
            break;

        case UIGestureRecognizerStateChanged : {
            [_scrollingController updatePan: gesture];
        }
            break;

        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled :
        case UIGestureRecognizerStateFailed : {

            [_scrollingController endPan: gesture];
            //            [self unembedController: _panningController];

        }
            break;

        case UIGestureRecognizerStatePossible : {

        }
            break;
    }

    return;
    UIView *nodeContainerView = _nodesController.view;
    //    CGPoint translation = [gesture translationInView: gesture.view.superview];

    if (gesture.numberOfTouches > 1) {
        CGPoint translation = [gesture translationInView: _nodesController.view.superview];
        CGPoint startPoint;

        switch (gesture.state) {
            case UIGestureRecognizerStateBegan : {
                [self startPan: gesture];
            }
                break;

            case UIGestureRecognizerStateChanged : {
                [self updatePan: gesture];
            }
                break;

            case UIGestureRecognizerStateEnded :
            case UIGestureRecognizerStateFailed :
            case UIGestureRecognizerStateCancelled : {
                [self endPan: gesture];
            }

                break;

            default :
                break;
        }
    }

    //    if (gesture.state == UIGestureRecognizerStateEnded ||
    //            gesture.state == UIGestureRecognizerStateFailed ||
    //            gesture.state == UIGestureRecognizerStateCancelled) {
    //
    //        NSLog(@"nodeContainerView.origin = %@", NSStringFromCGPoint(nodeContainerView.origin));
    //
    //        CGPoint startingOffset = nodeContainerView.origin;
    //        if (nodeContainerView.left > 0) {
    //            [nodeContainerView updateSuperWidthConstraint: nodeContainerView.left];
    //        }
    //        if (nodeContainerView.top > 0) {
    //            [nodeContainerView updateSuperHeightConstraint: nodeContainerView.top];
    //        }
    //
    //        //        for (TFBaseNodeView *node in self.nodeViews) {
    //        //            CGPoint nodePoint = CGPointMake(node.left + startingOffset.x, node.top + startingOffset.y);
    //        //            [node updateSuperLeadingConstraint: nodePoint.x];
    //        //            [node updateSuperTopConstraint: nodePoint.y];
    //        //            node.node.position = nodePoint;
    //        //        }
    //
    //        //        [lineView updateSuperLeadingConstraint: lineView.left - startingOffset.x];
    //        //        [lineView updateSuperTopConstraint: lineView.top - startingOffset.y];
    //
    //        [nodeContainerView updateSuperTopConstraint: 0];
    //        [nodeContainerView updateSuperLeadingConstraint: 0];
    //        [nodeContainerView setNeedsUpdateConstraints];
    //        [nodeContainerView layoutIfNeeded];
    //
    //        //        [self assignDelegate: self];
    //        //        [self redrawLines];
    //        //        [self assignDelegate: nil];
    //
    //    }
}


- (void) startPan: (UIPanGestureRecognizer *) gesture {

    _startingPoint = _nodesController.view.frame.origin;
    _bgController.view.userInteractionEnabled = NO;

    UIView *nodeContainerView = _nodesController.view;
    [nodeContainerView addDebugBorder: [UIColor redColor]];
    NSArray *constraints = [self.view constraintsAffectingItem: nodeContainerView];
    [self.view removeConstraints: constraints];

    //    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //
    //    CGSize extraSize = CGSizeMake(self.view.width - nodeContainerView.width, self.view.height - nodeContainerView.height);
    //
    //    CGSize currentSize = self.view.bounds.size;
    //
    //    [self.view addConstraints: @[
    //            [NSLayoutConstraint constraintWithItem: nodeContainerView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: currentSize.width],
    //            [NSLayoutConstraint constraintWithItem: nodeContainerView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: currentSize.height],
    //            [NSLayoutConstraint constraintWithItem: nodeContainerView attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],
    //            [NSLayoutConstraint constraintWithItem: nodeContainerView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
    //    ]];

    nodeContainerView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void) updatePan: (UIPanGestureRecognizer *) gesture {

    UIView *nodeContainerView = _nodesController.view;
    CGPoint startPoint = self.startingPoint;
    CGPoint translation = [gesture translationInView: _nodesController.view.superview];

    int option = 0;

    if (option == 0) {
        CGPoint newPoint = CGPointMake(_startingPoint.x + translation.x, _startingPoint.y + translation.y);

        nodeContainerView.left = _startingPoint.x + translation.x;
        nodeContainerView.top = _startingPoint.y + translation.y;
        nodeContainerView.width = self.view.width + newPoint.x;
        nodeContainerView.height = self.view.height - fabsf(translation.y);

        NSLog(@"translation = %@", NSStringFromCGPoint(translation));
    } else if (option == 1) {

        //    [nodeContainerView updateSuperCenterXConstraint: -translation.x];
        //    [nodeContainerView updateSuperCenterYConstraint: -translation.y];
        //    [nodeContainerView updateSuperLeadingConstraint: newPoint.x];
        //    [nodeContainerView updateSuperTopConstraint: newPoint.y];

        CGFloat extraWidth = fabsf(translation.x);
        CGFloat extraHeight = fabsf(translation.y);

        if (extraWidth > 0) {
            [nodeContainerView updateSuperWidthConstraint: -translation.x];
        }

        if (extraHeight > 0) {
            [nodeContainerView updateSuperHeightConstraint: -translation.y];
        }


        //
        //    if (newPoint.y < 0) {
        //        [nodeContainerView updateSuperHeightConstraint: -newPoint.y];
        //    }
    }

}

- (void) endPan: (UIPanGestureRecognizer *) gesture {

    //    self.view.translatesAutoresizingMaskIntoConstraints = YES;

    _bgController.view.userInteractionEnabled = YES;
}

#pragma mark Pinch

- (void) handlePinch: (UIPinchGestureRecognizer *) gesture {
    TFBaseNodeView *node = _nodesController.selectedNodeView;
    if (node == nil)
        return;

    [node.superview bringSubviewToFront: node];

    CGFloat newScale = fmaxf(0, (gesture.scale - 0.3) / 0.7);
    newScale = 1 - newScale;

    switch (gesture.state) {

        case UIGestureRecognizerStateBegan : {
            [_scrollingController startPinchWithScale: newScale];
        }
            break;

        case UIGestureRecognizerStateChanged : {
            if (gesture.scale < 1) {
                [_scrollingController updatePinchWithScale: newScale];
            }
        }
            break;

        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateFailed :
        case UIGestureRecognizerStateCancelled : {
            [_scrollingController endPinchWithScale: newScale];
        }
            break;

        default :
            break;
    }
}


#pragma mark - Utils

- (void) _refreshNodes {
    _nodesController.rootNode = _project.firstNode;
}

- (void) _refreshLines {
    _linesController.rootNode = _project.firstNode;
}


@end