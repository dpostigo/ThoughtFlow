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
@synthesize textLabel;
@synthesize debugView;

@synthesize normalView;
@synthesize greenView;

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

    self.translatesAutoresizingMaskIntoConstraints = NO;

    containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth,
            TFNodeViewHeight)];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: containerView];

    [self createGreenView];
    [self createRedView];
    [self createRelatedView];
    [self createNormalView];

    containerView.backgroundColor = [UIColor redColor];

    [self setupConstraints];
    [self setupGestures];
    [self setNeedsUpdateConstraints];
    self.nodeState = TFNodeViewStateNormal;

}


- (void) setupConstraints {

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

    [self updateWidthConstraint: TFNodeViewWidth];
    [self updateHeightConstraint: TFNodeViewHeight];
}


- (void) createNormalView {
    normalView = [[TFNodeStateView alloc] initWithFrame: self.bounds];
    normalView.translatesAutoresizingMaskIntoConstraints = NO;
    normalView.backgroundColor = [[self class] deselectedBackgroundColor];
    [containerView addSubview: normalView];
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
    [relatedButton addTarget: self action: @selector(handleRelatedButton:)
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


#pragma mark Handle Gestures
#pragma mark Gestures

- (void) handlePanGesture: (UIPanGestureRecognizer *) gesture {
    if (!enabled) return;

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan :
            isPanning = YES;
            startingPoint = containerView.origin;
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

    if ([self isRelatedGesture: gesture]) {
        [self handleRelatedPan: gesture];
    } else if (!isSnappingDown) {
        [self handleStatePan: gesture];
    }
}


- (void) handleRelatedPan: (UIPanGestureRecognizer *) gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) {
        CGPoint translation = [gesture translationInView: self];
        CGFloat newY = [self constrainPositionY: startingPoint.y + translation.y];
        //        containerView.top = newY;


        NSLayoutConstraint *leftConstraint = [containerView superLeadingConstraint];
        leftConstraint.constant = -TFNodeViewWidth;
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

- (void) endVerticalSnapping {
    isSnappingDown = NO;
}

- (BOOL) isRelatedGesture: (UIPanGestureRecognizer *) gesture {
    CGPoint translation = [gesture translationInView: gesture.view];
    return (translation.x == 0 || containerView.top != 0);

}


- (void) updateNodeState {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"containerView.origin = %@, self.nodeState = %@", NSStringFromCGPoint(containerView.origin),
            self.nodeStateAsString);

    if (containerView.top < 0) {
        self.nodeState = TFNodeViewStateRelated;
    } else if (containerView.left == 0) {
        self.nodeState = TFNodeViewStateCreate;

    } else if (containerView.left == -TFNodeViewWidth) {
        self.nodeState = TFNodeViewStateNormal;

    } else if (containerView.left == -TFNodeViewWidth * 2) {
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
        normalView.textLabel.text = node.title;
        nodeNotification = [[NSNotificationCenter defaultCenter] addObserverForName: TFNodeUpdate
                                                                             object: nil
                                                                              queue: nil
                                                                         usingBlock: ^(NSNotification *notification) {

                                                                             TFNode *aNode = notification.object;
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
    return [[self class] stringForNodeState: self.nodeState];
}

+ (NSString *) stringForNodeState: (TFNodeViewState) state {
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