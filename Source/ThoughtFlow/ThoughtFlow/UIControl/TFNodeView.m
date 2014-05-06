//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIColor+DPKit.h>
#import "TFNodeView.h"
#import "TFNodeStateView.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "UIGestureRecognizer+DPKit.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"
#import "TFNodeViewDelegate.h"
#import "UIImage+DPKit.h"
#import "TFNode.h"
#import "UIColor+Modify.h"

@implementation TFNodeView {
    CGPoint startingPoint;
}

@synthesize textLabel;
@synthesize normalView;
@synthesize debugView;

@synthesize greenView;

@synthesize delegate;
@synthesize nodeState;

@synthesize node;

@synthesize enabled;
@synthesize selected;
#define NODE_WIDTH 80

CGFloat const TFNodeViewWidth = 80;
CGFloat const TFNodeViewHeight = 80;

+ (UIView *) greenGhostView {
    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0, 0, NODE_WIDTH,
            NODE_WIDTH)];
    ret.backgroundColor = [UIColor tfGreenColor];

    return ret;
}



#pragma mark Setup

- (id) initWithFrame: (CGRect) frame {
    frame.size.width = TFNodeViewWidth;
    frame.size.height = TFNodeViewHeight;
    self = [super initWithFrame: frame];
    if (self) {
        [self setup];

    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    [self setup];

}

- (void) setup {
    enabled = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blueColor];

    containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth,
            TFNodeViewHeight)];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: containerView];

    [self createGreenView];
    [self createRedView];
    [self createRelatedView];

    normalView = [[TFNodeStateView alloc] initWithFrame: self.bounds];
    normalView.translatesAutoresizingMaskIntoConstraints = NO;
    normalView.backgroundColor = [[self class] deselectedBackgroundColor];
    [containerView addSubview: normalView];

    [greenButton updateSuperTopConstraint: 0];
    //    [greenButton updateSuperBottomConstraint: 0];
    [greenButton updateSuperLeadingConstraint: 0];
    [greenButton updateTrailingConstraint: 0 toSibling: normalView attribute: NSLayoutAttributeLeading];

    [normalView updateSuperTopConstraint: 0];
    //    [normalView updateSuperBottomConstraint: 0];
    [normalView updateTrailingConstraint: 0 toSibling: redButton attribute: NSLayoutAttributeLeading];

    [redButton updateSuperTopConstraint: 0];
    //    [redButton updateSuperBottomConstraint: 0];
    [redButton updateSuperTrailingConstraint: 0];

    [greenButton updateWidthConstraint: TFNodeViewWidth];
    [greenButton updateHeightConstraint: TFNodeViewHeight];
    [normalView updateWidthConstraint: TFNodeViewWidth];
    [normalView updateHeightConstraint: TFNodeViewHeight];
    [redButton updateWidthConstraint: TFNodeViewWidth];
    [redButton updateHeightConstraint: TFNodeViewHeight];
    [relatedButton updateWidthConstraint: TFNodeViewWidth];
    [relatedButton updateHeightConstraint: TFNodeViewHeight];

    [containerView updateSuperTopConstraint: 0];
    //    [containerView updateHeightConstraint: TFNodeViewHeight * 2];
    containerView.backgroundColor = [UIColor redColor];
    //    [containerView updateSuperBottomConstraint: 5];

    [self addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeCenterX
                                                      relatedBy: NSLayoutRelationEqual toItem: containerView
                                                      attribute: NSLayoutAttributeCenterX
                                                     multiplier: 1.0 constant: 0]];

    [containerView addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeTop
                                                               relatedBy: NSLayoutRelationEqual toItem: normalView
                                                               attribute: NSLayoutAttributeBottom
                                                              multiplier: 1.0 constant: 0]];

    [self addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeBottom
                                                      relatedBy: NSLayoutRelationEqual toItem: containerView
                                                      attribute: NSLayoutAttributeBottom
                                                     multiplier: 1.0 constant: 0]];

    containerView.left = [self positionForNodeState: TFNodeViewStateNormal];
    [self setNeedsUpdateConstraints];
    [self setupGestures];

    containerView.left = [self positionForNodeState: TFNodeViewStateNormal];
    containerView.left = 0;

}


- (void) createGreenView {
    greenView = [[TFNodeStateView alloc] initWithFrame: self.bounds];
    greenView.textLabel.text = @"DRAG OUT";
    greenView.textLabel.font = [UIFont gothamLight: 12];
    greenView.textLabel.textColor = [UIColor whiteColor];
    greenView.translatesAutoresizingMaskIntoConstraints = NO;
    greenView.backgroundColor = [UIColor tfGreenColor];
    [greenView.button addTarget: self action: @selector(handleGreenButton:)
               forControlEvents: UIControlEventTouchUpInside];
    //    [containerView addSubview: greenView];

    greenView.textLabel.text = @"";
    [greenView.button setTitle: @"DRAG OUT" forState: UIControlStateNormal];

    greenButton = [UIButton buttonWithType: UIButtonTypeCustom];
    greenButton.frame = self.bounds;
    greenButton.backgroundColor = [UIColor tfGreenColor];
    greenButton.titleLabel.font = [UIFont gothamLight: 12];
    //    greenButton.titleLabel.textColor = [UIColor whiteColor];
    greenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [greenButton setTitle: @"DRAG OUT" forState: UIControlStateNormal];
    [greenButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [greenButton addTarget: self action: @selector(handleGreenButton:)
          forControlEvents: UIControlEventTouchDragInside];
    greenButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    greenButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    greenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    greenButton.adjustsImageWhenHighlighted = YES;
    //    greenButton.reversesTitleShadowWhenHighlighted = YES;
    //    [greenButton setBackgroundImage: [UIImage imageWithColor: [greenButton.backgroundColor darkenColor: 0.1]]
    //                           forState: UIControlStateHighlighted];
    //    greenButton.userInteractionEnabled = NO;
    [containerView addSubview: greenButton];
}

- (void) createRedView {
    redButton = [UIButton buttonWithType: UIButtonTypeCustom];
    redButton.frame = self.bounds;
    redButton.backgroundColor = [UIColor tfRedColor];
    redButton.titleLabel.font = [UIFont gothamLight: 12];
    redButton.titleLabel.textColor = [UIColor whiteColor];
    redButton.translatesAutoresizingMaskIntoConstraints = NO;
    [redButton setTitle: @"DELETE" forState: UIControlStateNormal];
    [redButton addTarget: self action: @selector(handleRedButton:)
        forControlEvents: UIControlEventTouchUpInside];
    redButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    redButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    redButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: redButton];
}


- (void) createRelatedView {
    relatedButton = [UIButton buttonWithType: UIButtonTypeCustom];
    relatedButton.frame = self.bounds;
    relatedButton.backgroundColor = [UIColor tfPurpleColor];
    relatedButton.titleLabel.font = [UIFont gothamLight: 12];
    relatedButton.titleLabel.textColor = [UIColor whiteColor];
    relatedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [relatedButton setTitle: @"RELATED" forState: UIControlStateNormal];
    [relatedButton addTarget: self action: @selector(handleRedButton:)
            forControlEvents: UIControlEventTouchUpInside];
    relatedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    relatedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    relatedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: relatedButton];

}

- (void) setupGestures {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                          action: @selector(handlePanGesture:)];


    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                action: @selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                action: @selector(toggleSelection:)];
    singleTap.numberOfTapsRequired = 1;

    //    [containerView addGestureRecognizer: swipe];
    [containerView addGestureRecognizer: pan];
    [normalView addGestureRecognizer: doubleTap];
    [normalView addGestureRecognizer: singleTap];

}



#pragma mark Handle buttons

- (void) handleGreenButton: (id) sender {
    if (!isPanning) {
        NSLog(@"%s", __PRETTY_FUNCTION__);

    }
}

- (void) handleRedButton: (id) sender {
    [self nodeViewDidTriggerDeletion];
}


- (void) handleNodeButton: (id) sender {

}


#pragma mark Handle Gestures
#pragma mark Gestures

- (void) handlePanGesture: (UIPanGestureRecognizer *) gesture {
    if (!enabled) return;

    CGPoint translation = [gesture translationInView: gesture.view];
    //    NSLog(@"translation = %@", NSStringFromCGPoint(translation));

    if (gesture.state == UIGestureRecognizerStateBegan) {
        isPanning = YES;
        startingPoint = containerView.origin;
        [self disableButtons];
    }

    if (gesture.state == UIGestureRecognizerStateCancelled ||
            gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateFailed) {
        isPanning = NO;
    }

    if (translation.x == 0 || containerView.top != 0) {
        [self handleRelatedPan: gesture];
    } else if (!isSnappingDown) {
        [self handleStatePan: gesture];
    }

}

- (void) handleSwipeUp: (UISwipeGestureRecognizer *) gesture {

    CGPoint location = [gesture locationInView: gesture.view];
    //    NSLog(@"location = %@", NSStringFromCGPoint(location));

}

- (void) handleRelatedPan: (UIPanGestureRecognizer *) gesture {

    if (gesture.state != UIGestureRecognizerStateBegan) {
        CGPoint translation = [gesture translationInView: self];
        CGFloat newY = [self constrainPositionY: startingPoint.y + translation.y];
        //        containerView.top = newY;


        NSLayoutConstraint *constraint = containerView.superTopConstraint;
        constraint.constant = newY;

        if (gesture.state == UIGestureRecognizerStateEnded) {

            CGPoint velocity = [gesture velocityInView: self];

            CGFloat snapY = [self constrainPositionY: roundf(containerView.top / self.height) * self.height];
            //
            CGPoint vel = [gesture velocityInView: self];
            CGFloat curY = containerView.frame.origin.y;
            CGFloat springVelocity = (-0.1f * vel.x) / (curY - snapY);

            //            NSLog(@"vel.x = %f", vel.x);


            isSnappingDown = YES;

            constraint.constant = snapY;
            [self setNeedsUpdateConstraints];
            [UIView animateWithDuration: 0.4 delay: 0.0
                 usingSpringWithDamping: 0.9f
                  initialSpringVelocity: springVelocity
                                options: UIViewAnimationOptionCurveEaseOut
                             animations: ^{
                                 //                                 containerView.top = snapY;
                                 [self layoutIfNeeded];
                             }
                             completion: ^(BOOL finished) {
                                 [self updateNodeState];
                                 [self enableButtons];
                                 isSnappingDown = NO;
                                 //                                 [self performSelector: @selector(endVerticalSnapping) withObject: nil
                                 //                                            afterDelay: 0.4];
                             }];

        }
    }
}

- (void) endVerticalSnapping {

    isSnappingDown = NO;
}

- (void) handleStatePan: (UIPanGestureRecognizer *) gesture {

    UIView *view = self;
    if (gesture.state != UIGestureRecognizerStateBegan) {

        CGPoint translation = [gesture translationInView: view];
        CGFloat newX = [self constrainPositionX: startingPoint.x + (translation.x)];
        containerView.left = newX;

        if (gesture.state == UIGestureRecognizerStateChanged) {

        } else if (gesture.state == UIGestureRecognizerStateEnded) {

            CGPoint velocity = [gesture velocityInView: view];
            if (velocity.x > 0) {

                //            [self.interactionController finishInteractiveTransition];
            } else {
                //            [self.interactionController cancelInteractiveTransition];
            }

            CGFloat snapX = [self constrainPositionX: roundf(containerView.left / self.width) * self.width];

            CGPoint vel = [gesture velocityInView: view];
            CGFloat curX = containerView.frame.origin.x;
            CGFloat springVelocity = (-0.1f * vel.x) / (curX - snapX);

            //            NSLog(@"vel.x = %f", vel.x);

            [UIView animateWithDuration: 0.4 delay: 0.0
                 usingSpringWithDamping: 0.9f
                  initialSpringVelocity: springVelocity
                                options: UIViewAnimationOptionCurveEaseOut
                             animations: ^{
                                 CGRect frame = containerView.frame;
                                 frame.origin.x = snapX;
                                 containerView.frame = frame;
                             }
                             completion: ^(BOOL finished) {
                                 [self updateNodeState];
                                 [self enableButtons];
                             }];

        }
    }

}

- (void) handleDoubleTap: (id) gesture {
    [self nodeViewDidDoubleTap];

}

- (void) handleSwipe: (UISwipeGestureRecognizer *) swipe {
}


#pragma mark Enable / disable buttons

- (void) enableButtons {
    NSArray *buttons = [NSArray arrayWithObjects: greenButton, redButton, nil];

    for (UIButton *button in buttons) {
        button.enabled = YES;
    }
}


- (void) disableButtons {
    NSArray *buttons = [NSArray arrayWithObjects: greenButton, redButton, nil];
    for (UIButton *button in buttons) {
        button.enabled = NO;
    }
}


#pragma mark Positioning


- (CGFloat) constrainPositionX: (CGFloat) snapX {
    const CGFloat absoluteMaxX = 0;
    const CGFloat absoluteMinX = -containerView.width + TFNodeViewWidth;

    CGFloat maxX = fminf(absoluteMaxX, startingPoint.x + NODE_WIDTH);
    CGFloat minX = fmaxf(absoluteMinX, startingPoint.x - NODE_WIDTH);

    //    NSLog(@"startingPoint.x = %f, maxX = %f, minX = %f", startingPoint.x, maxX, minX);

    CGFloat ret = snapX;
    ret = fminf(ret, maxX);
    ret = fmaxf(ret, minX);

    //    NSLog(@"snapX = %f, ret = %f", snapX, ret);

    return ret;
}


- (CGFloat) constrainPositionY: (CGFloat) posY {
    const CGFloat absoluteMinY = -TFNodeViewHeight;
    const CGFloat absoluteMaxY = 0;

    CGFloat ret = posY;
    ret = fmaxf(ret, absoluteMinY);
    ret = fminf(ret, absoluteMaxY);
    return ret;

}

- (void) snap {
    CGFloat snapX = roundf(containerView.left / self.width) * self.width;
    snapX = fmaxf(snapX, -self.width);
    snapX = fminf(snapX, 0);

    [UIView animateWithDuration: 0.3 animations: ^{
        containerView.left = snapX;
        [self updateNodeState];
    }];

}


- (void) updateNodeState {
    if (containerView.left < 0) {
        self.nodeState = TFNodeViewStateRelated;
    }
    else if (containerView.left == 0) {
        self.nodeState = TFNodeViewStateCreate;

    } else if (containerView.left == -NODE_WIDTH) {
        self.nodeState = TFNodeViewStateNormal;

    } else if (containerView.left == -NODE_WIDTH * 2) {
        self.nodeState = TFNodeViewStateDelete;
    }
}



#pragma mark Text

- (NSString *) text {
    return normalView.textLabel.text;
}

- (void) setText: (NSString *) text {
    normalView.textLabel.text = text;
}


#pragma mark Setters


- (void) setNode: (TFNode *) node1 {

    //    if (nodeNotification) [[NSNotificationCenter defaultCenter] removeObserver: nodeNotification];
    if (node != node1) {
        node = node1;
        NSLog(@"normalView = %@", normalView);
        NSLog(@"node.title = %@", node.title);
        normalView.textLabel.text = node.title;
        nodeNotification = [[NSNotificationCenter defaultCenter] addObserverForName: TFNodeUpdate
                                                                             object: nil
                                                                              queue: nil
                                                                         usingBlock: ^(NSNotification *notification) {

                                                                             TFNode *aNode = notification.object;
                                                                             NSLog(@"aNode = %@", aNode);
                                                                             if (notification.object == self.node) {

                                                                             }
                                                                             normalView.textLabel.text = self.node.title;

                                                                         }];
    }

}

- (void) setNodeState: (TFNodeViewState) nodeState1 {
    [self setNodeState: nodeState1 animated: NO];
}

- (void) setNodeState: (TFNodeViewState) nodeState1 animated: (BOOL) flag {
    if (nodeState1 != nodeState) {

        void (^completionBlock)(BOOL finished) = ^(BOOL finished) {
            nodeState = nodeState1;
            [self nodeViewDidChangeState];
        };

        if (flag) {
            [UIView animateWithDuration: 0.3
                             animations: ^{
                                 containerView.left = [self positionForNodeState: nodeState1];
                             }
                             completion: completionBlock];
        } else {
            completionBlock(YES);
        }
    }
}


- (CGFloat) positionForNodeState: (TFNodeViewState) state {
    CGFloat ret = 0;
    if (state == TFNodeViewStateCreate) {
        ret = 0;
    } else if (state == TFNodeViewStateNormal) {
        ret = -NODE_WIDTH;
    } else if (state == TFNodeViewStateDelete) {
        ret = -NODE_WIDTH * 2;
    }
    return ret;
}

#pragma mark Delegate notifications

- (void) nodeViewDidDoubleTap {
    if (delegate && [delegate respondsToSelector: @selector(nodeViewDidDoubleTap:)]) {
        [delegate performSelector: @selector(nodeViewDidDoubleTap:) withObject: self];
    }
}

- (void) nodeViewDidChangeState {
    if (delegate && [delegate respondsToSelector: @selector(nodeViewDidChangeState:)]) {
        [delegate performSelector: @selector(nodeViewDidChangeState:) withObject: self];
    }
}

- (void) nodeViewDidChangeSelection {
    if (delegate && [delegate respondsToSelector: @selector(nodeViewDidChangeSelection:)]) {
        [delegate performSelector: @selector(nodeViewDidChangeSelection:) withObject: self];
    }
}

- (void) nodeViewDidTriggerDeletion {
    if (delegate && [delegate respondsToSelector: @selector(nodeViewDidTriggerDeletion:)]) {
        [delegate performSelector: @selector(nodeViewDidTriggerDeletion:) withObject: self];
    }
}

#pragma mark Getters

//
//- (TFNodeStateView *) normalView {
//    if (normalView == nil) {
//        normalView = [[TFNodeStateView alloc] init];
//        [self addSubview: normalView];
//    }
//    return normalView;
//}


- (void) setFrame: (CGRect) frame {
    [super setFrame: frame];

    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (node) {
        node.position = frame.origin;
    }
}


#pragma mark Setters

- (void) setSelected: (BOOL) selected1 {
    if (selected != selected1) {
        selected = selected1;
        normalView.backgroundColor = selected ? [UIColor whiteColor] : [[self class] deselectedBackgroundColor];
        [self nodeViewDidChangeSelection];
    }
}


- (void) toggleSelection: (id) sender {
    self.selected = !self.selected;
}

+ (UIColor *) deselectedBackgroundColor {
    return [UIColor colorWithString: @"bdbdbe"];
}


- (NSString *) nodeStateAsString {
    return [self stringForNodeState: self.nodeState];
}

- (NSString *) stringForNodeState: (TFNodeViewState) state {
    NSString *ret = nil;
    if (state == TFNodeViewStateNone) {
        ret = @"TFNodeViewStateNone";
    } else if (state == TFNodeViewStateNormal) {
        ret = @"TFNodeViewStateNormal";
    } else if (state == TFNodeViewStateCreate) {
        ret = @"TFNodeViewStateCreate";
    } else if (state == TFNodeViewStateDelete) {
        ret = @"TFNodeViewStateDelete";
    } else if (state == TFNodeViewStateRelated) {
        ret = @"TFNodeViewStateRelated";
    }
    return ret;
}

@end