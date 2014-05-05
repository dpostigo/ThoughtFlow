//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

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

#define NODE_WIDTH 80

CGFloat const TFNodeViewWidth = 80;
CGFloat const TFNodeViewHeight = 80;

+ (UIView *) greenNode {
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
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blueColor];

    containerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth,
            TFNodeViewHeight)];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview: containerView];

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
          forControlEvents: UIControlEventTouchUpInside];
    greenButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    greenButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    greenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    greenButton.adjustsImageWhenHighlighted = YES;
    //    greenButton.reversesTitleShadowWhenHighlighted = YES;
    //    [greenButton setBackgroundImage: [UIImage imageWithColor: [greenButton.backgroundColor darkenColor: 0.1]]
    //                           forState: UIControlStateHighlighted];
    greenButton.userInteractionEnabled = NO;
    [containerView addSubview: greenButton];

    redButton = [UIButton buttonWithType: UIButtonTypeCustom];
    redButton.frame = self.bounds;
    redButton.backgroundColor = [UIColor tfRedColor];
    redButton.titleLabel.font = [UIFont gothamLight: 12];
    redButton.titleLabel.textColor = [UIColor whiteColor];
    redButton.translatesAutoresizingMaskIntoConstraints = NO;
    [redButton setTitle: @"DELETE" forState: UIControlStateNormal];
    [redButton addTarget: self action: @selector(handleGreenButton:)
        forControlEvents: UIControlEventTouchUpInside];
    redButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    redButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    redButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: redButton];

    normalView = [[TFNodeStateView alloc] initWithFrame: self.bounds];
    normalView.translatesAutoresizingMaskIntoConstraints = NO;
    normalView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview: normalView];

    [greenButton updateSuperTopConstraint: 0];
    [greenButton updateSuperBottomConstraint: 0];
    [greenButton updateSuperLeadingConstraint: 0];

    [greenButton updateTrailingConstraint: 0 toSibling: normalView attribute: NSLayoutAttributeLeading];

    [normalView updateSuperTopConstraint: 0];
    [normalView updateSuperBottomConstraint: 0];
    [normalView updateTrailingConstraint: 0 toSibling: redButton attribute: NSLayoutAttributeLeading];

    [redButton updateSuperTopConstraint: 0];
    [redButton updateSuperBottomConstraint: 0];
    [redButton updateSuperTrailingConstraint: 0];

    [greenButton updateWidthConstraint: NODE_WIDTH];
    [normalView updateWidthConstraint: NODE_WIDTH];
    [redButton updateWidthConstraint: NODE_WIDTH];

    [containerView updateSuperTopConstraint: 5];
    [containerView updateSuperBottomConstraint: 5];

    containerView.left = [self positionForNodeState: TFNodeViewStateNormal];
    [self setNeedsUpdateConstraints];
    [self addGestures];

    containerView.left = [self positionForNodeState: TFNodeViewStateNormal];
    NSLog(@"containerView.left = %f", containerView.left);

}

- (void) handleGreenButton: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void) handleNodeButton: (id) sender {

}


- (void) addGestures {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget: self
                                                                              action: @selector(handlePanGesture:)];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                action: @selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;

    [containerView addGestureRecognizer: gesture];
    [normalView addGestureRecognizer: doubleTap];

}


#pragma mark Handle Gestures

- (void) handleDoubleTap: (id) gesture {
    [self nodeViewDidDoubleTap];

}

- (void) handleSwipe: (UISwipeGestureRecognizer *) swipe {
}


- (void) handlePanGesture: (UIPanGestureRecognizer *) gesture {
    [self handlePanGesture2: gesture];

}

- (void) handlePanGesture2: (UIPanGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        startingPoint = containerView.origin;
        [self disableButtons];
    }

    UIView *view = self;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gesture locationInView: view];
        if (location.x < CGRectGetMidX(view.bounds)) {

        }
    }

    else {

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

            NSLog(@"vel.x = %f", vel.x);

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

- (void) handlePanGesture1: (UIPanGestureRecognizer *) gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {
        startingPoint = containerView.origin;
    }

    CGPoint point = [gesture translationInView: self];

    CGPoint velocity = [gesture velocityInView: self];
    NSLog(@"velocity.x = %f", velocity.x);

    CGFloat newX = startingPoint.x + (point.x * 0.5);
    newX = fmaxf(newX, -self.width);
    newX = fminf(newX, 0);
    containerView.left = newX;

    if (fabsf(velocity.x) > 500) {
        [self snap];
    }

    if (gesture.state == UIGestureRecognizerStateChanged) {

    } else if (gesture.state == UIGestureRecognizerStateEnded) {

        [self snap];

    }

    if (gesture.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"gesture.stateAsString = %@", gesture.stateAsString);

    }
}

- (CGFloat) constrainPositionX: (CGFloat) snapX {
    CGFloat padding = (containerView.width - self.width) / 2;

    snapX = fmaxf(snapX, -self.width * 2);
    snapX = fmaxf(snapX, -(containerView.width - self.width));
    snapX = fminf(snapX, 0);
    return snapX;
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
    if (containerView.left == 0) {
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


@end