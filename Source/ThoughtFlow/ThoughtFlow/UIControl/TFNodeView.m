//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIColor+DPKit.h>
#import "TFNodeView.h"
#import "TFNodeStateView.h"
#import "UIView+DPConstraints.h"
#import "UIView+DPKit.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"
#import "TFNodeViewDelegate.h"
#import "TFNode.h"
#import "TFNodeView+Utils.h"

@implementation TFNodeView

@synthesize node;
@synthesize nodeState;
@synthesize delegate;
@synthesize enabled;
@synthesize selected;
@synthesize debugView;

@synthesize viewNormal;

@synthesize optimized;
@synthesize swipeDirection;

@synthesize nodeUpdateDisabled;

CGFloat const TFNodeViewWidth = 80;
CGFloat const TFNodeViewHeight = 80;

+ (UIView *) greenGhostView {
    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth,
            TFNodeViewHeight)];
    ret.backgroundColor = [UIColor tfGreenColor];

    return ret;
}



#pragma mark Setup



- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: CGRectMake(frame.origin.x, frame.origin.y, TFNodeViewWidth, TFNodeViewHeight)];
    if (self) {
        [self setup];
    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setup];
}


#pragma mark Setup

- (void) setup {
    enabled = YES;

    [self _setupView];
    [self _setupContainerView];

    [self _setupGreenView];
    [self _setupRedView];
    [self _setupRelatedView];
    [self _setupNormalView];

    [self _setupConstraints];
    [self _setupGestures];

    [self setNeedsUpdateConstraints];
    self.nodeState = TFNodeViewStateNormal;

}


- (void) _setupView {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) _setupContainerView {
    _containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    [self addSubview: _containerView];

}

- (void) _setupConstraints {

    [greenButton updateSuperTopConstraint: 0];
    //    [greenButton updateSuperBottomConstraint: 0];
    [greenButton updateSuperLeadingConstraint: 0];
    [greenButton updateTrailingConstraint: 0 toSibling: viewNormal attribute: NSLayoutAttributeLeading];

    [viewNormal updateSuperTopConstraint: 0];
    //    [viewNormal updateSuperBottomConstraint: 0];
    [viewNormal updateTrailingConstraint: 0 toSibling: redButton attribute: NSLayoutAttributeLeading];

    [redButton updateSuperTopConstraint: 0];
    //    [redButton updateSuperBottomConstraint: 0];
    [redButton updateSuperTrailingConstraint: 0];

    [greenButton updateWidthConstraint: TFNodeViewWidth];
    [greenButton updateHeightConstraint: TFNodeViewHeight];
    [viewNormal updateWidthConstraint: TFNodeViewWidth];
    [viewNormal updateHeightConstraint: TFNodeViewHeight];
    [redButton updateWidthConstraint: TFNodeViewWidth];
    [redButton updateHeightConstraint: TFNodeViewHeight];
    [relatedButton updateWidthConstraint: TFNodeViewWidth];
    [relatedButton updateHeightConstraint: TFNodeViewHeight];

    [self.containerView updateSuperTopConstraint: 0];
    //    [containerView updateHeightConstraint: TFNodeViewHeight * 2];
    //    [containerView updateSuperBottomConstraint: 5];

    [self addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeCenterX
            relatedBy: NSLayoutRelationEqual toItem: self.containerView
            attribute: NSLayoutAttributeCenterX
            multiplier: 1.0 constant: 0]];

    [self.containerView addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeTop
            relatedBy: NSLayoutRelationEqual toItem: viewNormal
            attribute: NSLayoutAttributeBottom
            multiplier: 1.0 constant: 0]];

    [self addConstraint: [NSLayoutConstraint constraintWithItem: relatedButton attribute: NSLayoutAttributeBottom
            relatedBy: NSLayoutRelationEqual toItem: self.containerView
            attribute: NSLayoutAttributeBottom
            multiplier: 1.0 constant: 0]];

    [self updateWidthConstraint: TFNodeViewWidth];
    [self updateHeightConstraint: TFNodeViewHeight];
}


- (void) _setupGestures {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePanGesture:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleSelection:)];
    singleTap.numberOfTapsRequired = 1;

    [self.containerView addGestureRecognizer: pan];
    [viewNormal addGestureRecognizer: doubleTap];
    [viewNormal addGestureRecognizer: singleTap];

}



#pragma mark Handle buttons

- (void) handleGreenButton: (id) sender {
    if (!isPanning) {

    }
}

- (void) handleRedButton: (id) sender {
    [self nodeViewDidTriggerDeletion];
}


- (void) handleNodeButton: (id) sender {

}

- (void) handleRelatedButton: (UIButton *) button {
    [self nodeViewDidTriggerRelated];

}


#pragma mark Gestures

- (void) handlePanGesture: (UIPanGestureRecognizer *) gesture {
    if (!enabled) return;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            isPanning = YES;
            startingPoint = self.containerView.origin;
            [self disableButtons];
            break;

        case UIGestureRecognizerStateCancelled :
        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateFailed :
            isPanning = NO;
            break;

        default :
            break;
    }

    CGPoint translation = [gesture translationInView: gesture.view];

    if ((translation.x == 0 || self.containerView.top != 0) && swipeDirection != TFSwipeDirectionHorizontal) {
        [self panVertically: gesture];

    } else if (!isSnappingDown && swipeDirection != TFSwipeDirectionVertical) {
        [self panHorizontally: gesture];
    }

    if (swipeDirection == TFSwipeDirectionNone) {
        if (fabsf(self.containerView.top) > 20) {
            swipeDirection = TFSwipeDirectionVertical;
        } else if (fabsf(self.containerView.left + 80) > 20) {
            swipeDirection = TFSwipeDirectionHorizontal;
        }
    }

    if (gesture.state == UIGestureRecognizerStateEnded) {
        swipeDirection = TFSwipeDirectionNone;
    }
}


- (void) panVertically: (UIPanGestureRecognizer *) gesture {

    CGPoint translation = [gesture translationInView: self];
    CGFloat newY = [self constrainPositionY: startingPoint.y + translation.y];
    NSLayoutConstraint *leftConstraint = [self.containerView superLeadingConstraint];
    NSLayoutConstraint *topConstraint = self.containerView.superTopConstraint;

    switch (gesture.state) {

        case UIGestureRecognizerStateChanged : {
            leftConstraint.constant = -TFNodeViewWidth;
            topConstraint.constant = newY;

            if (fabsf(newY) > 10) {
                swipeDirection = TFSwipeDirectionVertical;
            }
        }
            break;

        case UIGestureRecognizerStateEnded :
        case UIGestureRecognizerStateCancelled :
        case UIGestureRecognizerStateFailed : {
            CGPoint velocity = [gesture velocityInView: self];

            CGFloat snapY = [self constrainPositionY: roundf(self.containerView.top / self.height) * self.height];

            CGPoint vel = [gesture velocityInView: self];
            CGFloat curY = self.containerView.frame.origin.y;
            CGFloat springVelocity = (-0.1f * vel.x) / (curY - snapY);

            isSnappingDown = YES;

            topConstraint.constant = snapY;
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
            break;

        default :
            break;

    }
    //    if (gesture.state != UIGestureRecognizerStateBegan) {
    //        CGPoint translation = [gesture translationInView: self];
    //        CGFloat newY = [self constrainPositionY: startingPoint.y + translation.y];
    //
    //
    //        NSLayoutConstraint *leftConstraint = [containerView superLeadingConstraint];
    //        leftConstraint.constant = -TFNodeViewWidth;
    //        NSLayoutConstraint *constraint = containerView.superTopConstraint;
    //        topConstraint.constant = newY;
    //
    //        if (gesture.state == UIGestureRecognizerStateEnded) {
    //
    //            CGPoint velocity = [gesture velocityInView: self];
    //
    //            CGFloat snapY = [self constrainPositionY: roundf(containerView.top / self.height) * self.height];
    //
    //            CGPoint vel = [gesture velocityInView: self];
    //            CGFloat curY = containerView.frame.origin.y;
    //            CGFloat springVelocity = (-0.1f * vel.x) / (curY - snapY);
    //
    //            isSnappingDown = YES;
    //
    //            topConstraint.constant = snapY;
    //            [self setNeedsUpdateConstraints];
    //            [UIView animateWithDuration: 0.4 delay: 0.0
    //                 usingSpringWithDamping: 0.9f
    //                  initialSpringVelocity: springVelocity
    //                                options: UIViewAnimationOptionCurveEaseOut
    //                             animations: ^{
    //                                 //                                 containerView.top = snapY;
    //                                 [self layoutIfNeeded];
    //                             }
    //                             completion: ^(BOOL finished) {
    //                                 [self updateNodeState];
    //                                 [self enableButtons];
    //                                 isSnappingDown = NO;
    //                                 //                                 [self performSelector: @selector(endVerticalSnapping) withObject: nil
    //                                 //                                            afterDelay: 0.4];
    //                             }];
    //
    //        }
    //    }
}

- (void) panHorizontally: (UIPanGestureRecognizer *) gesture {

    UIView *view = self;
    if (gesture.state != UIGestureRecognizerStateBegan) {

        CGPoint translation = [gesture translationInView: view];
        CGFloat newX = [self constrainPositionX: startingPoint.x + (translation.x)];
        self.containerView.left = newX;

        if (gesture.state == UIGestureRecognizerStateChanged) {

        } else if (gesture.state == UIGestureRecognizerStateEnded) {

            CGPoint velocity = [gesture velocityInView: view];
            if (velocity.x > 0) {

                //            [self.interactionController finishInteractiveTransition];
            } else {
                //            [self.interactionController cancelInteractiveTransition];
            }

            CGFloat snapX = [self constrainPositionX: roundf(self.containerView.left / self.width) * self.width];

            CGPoint vel = [gesture velocityInView: view];
            CGFloat curX = self.containerView.frame.origin.x;
            CGFloat springVelocity = (-0.1f * vel.x) / (curX - snapX);

            //            NSLog(@"vel.x = %f", vel.x);

            [UIView animateWithDuration: 0.4 delay: 0.0
                    usingSpringWithDamping: 0.9f
                    initialSpringVelocity: springVelocity
                    options: UIViewAnimationOptionCurveEaseOut
                    animations: ^{
                        CGRect frame = self.containerView.frame;
                        frame.origin.x = snapX;
                        self.containerView.frame = frame;
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

- (void) endVerticalSnapping {
    isSnappingDown = NO;
}

- (BOOL) isRelatedGesture: (UIPanGestureRecognizer *) gesture {
    CGPoint translation = [gesture translationInView: gesture.view];
    return (translation.x == 0 || self.containerView.top != 0);

}


- (void) updateNodeState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"containerView.origin = %@, self.nodeState = %@", NSStringFromCGPoint(self.containerView.origin),
            self.nodeStateAsString);

    if (self.containerView.top < 0) {
        self.nodeState = TFNodeViewStateRelated;
    } else if (self.containerView.left == 0) {
        self.nodeState = TFNodeViewStateCreate;

    } else if (self.containerView.left == -TFNodeViewWidth) {
        self.nodeState = TFNodeViewStateNormal;

    } else if (self.containerView.left == -TFNodeViewWidth * 2) {
        self.nodeState = TFNodeViewStateDelete;
    }
}




#pragma mark Text

- (NSString *) text {
    return viewNormal.currentTitle;
}

- (void) setText: (NSString *) text {
    [viewNormal setTitle: text forState: UIControlStateNormal];
}


#pragma mark Setters


- (void) setNode: (TFNode *) node1 {

    if (node != node1) {
        node = node1;

        [viewNormal setTitle: node.title forState: UIControlStateNormal];
        nodeNotification = [[NSNotificationCenter defaultCenter] addObserverForName: TFNodeUpdate
                object: nil
                queue: nil
                usingBlock: ^(NSNotification *notification) {

                    TFNode *aNode = notification.object;
                    if (notification.object == self.node) {

                    }
                    [viewNormal setTitle: node.title forState: UIControlStateNormal];

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
                        self.containerView.left = [self positionForNodeState: nodeState1];
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
        ret = -TFNodeViewWidth;
    } else if (state == TFNodeViewStateDelete) {
        ret = -TFNodeViewWidth * 2;
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


- (void) nodeViewDidTriggerRelated {
    if (delegate && [delegate respondsToSelector: @selector(nodeViewDidTriggerRelated:)]) {
        [delegate performSelector: @selector(nodeViewDidTriggerRelated:) withObject: self];
    }
}

#pragma mark Getters



#pragma mark Setters


- (void) setFrame: (CGRect) frame {
    [super setFrame: frame];

    //    if (!nodeUpdateDisabled && node) {
    //        node.position = frame.origin;
    //    }
}

- (void) setSelected: (BOOL) selected1 {
    if (selected != selected1) {
        selected = selected1;
        viewNormal.backgroundColor = selected ? [UIColor whiteColor] : [UIColor deselectedNodeBackgroundColor];
        if (selected) [self nodeViewDidChangeSelection];
    }
}


- (void) setOptimized: (BOOL) optimized1 {
    if (optimized != optimized1) {
        optimized = optimized1;

        if (optimized) {
            self.backgroundColor = viewNormal.backgroundColor;
            [self.containerView removeFromSuperview];
            [self addSubview: viewNormal];
            [viewNormal updateSuperEdgeConstraints: 0];
            //            self.alpha = 0.5;

        } else {

            [self.containerView addSubview: viewNormal];
            [self addSubview: self.containerView];
            [self _setupConstraints];
            //            self.alpha = 1.0;
        }
    }
}

@end