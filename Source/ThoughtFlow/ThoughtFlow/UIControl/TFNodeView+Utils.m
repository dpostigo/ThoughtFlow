//
// Created by Dani Postigo on 5/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIColor+DPKit.h>
#import "TFNodeView+Utils.h"
#import "TFNodeStateView.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"
#import "UIButton+TFNodeView.h"

@implementation TFNodeView (Utils)

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
    const CGFloat absoluteMinX = -containerView.frame.size.width + TFNodeViewWidth;

    CGFloat maxX = fminf(absoluteMaxX, startingPoint.x + TFNodeViewWidth);
    CGFloat minX = fmaxf(absoluteMinX, startingPoint.x - TFNodeViewWidth);

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

#pragma mark Setup



- (void) createNormalView {
    UIButton *ret = [UIButton buttonWithType: UIButtonTypeCustom];
    ret.frame = self.bounds;
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    ret.backgroundColor = [UIColor deselectedNodeBackgroundColor];
    ret.titleLabel.font = [UIFont italicSerif: 14];
    ret.titleLabel.textColor = [UIColor blackColor];
    ret.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    ret.titleLabel.textAlignment = NSTextAlignmentCenter;
    ret.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [ret setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [containerView addSubview: ret];
    viewNormal = ret;
}

- (void) createGreenView {

    UIButton *ret = [UIButton buttonWithType: UIButtonTypeCustom];
    ret.frame = self.bounds;
    ret.backgroundColor = [UIColor tfGreenColor];
    ret.titleLabel.font = [UIFont gothamLight: 12];
    //    ret.titleLabel.textColor = [UIColor whiteColor];
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    ret.adjustsImageWhenDisabled = NO;
    ret.adjustsImageWhenHighlighted = NO;
    //    [ret setTitle: @"DRAG OUT" forState: UIControlStateNormal];
    //    [ret setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [ret setImage: [UIImage imageNamed: @"node-dragout-image"] forState: UIControlStateNormal];
    [ret addTarget: self action: @selector(handleGreenButton:) forControlEvents: UIControlEventTouchDragOutside];
    ret.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    ret.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    ret.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: ret];
    greenButton = ret;
}

- (void) createRedView {
    UIButton *ret = [UIButton buttonWithType: UIButtonTypeCustom];
    ret.frame = self.bounds;
    ret.backgroundColor = [UIColor tfRedColor];
    ret.titleLabel.font = [UIFont gothamLight: 12];
    ret.titleLabel.textColor = [UIColor whiteColor];
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    ret.adjustsImageWhenDisabled = NO;
    ret.adjustsImageWhenHighlighted = NO;
    //    [ret setTitle: @"DELETE" forState: UIControlStateNormal];
    //    UIImage *image = [UIImage imageNamed: @"icon-node-delete"];
    //    ret.titleEdgeInsets = UIEdgeInsetsMake(40, -20, 0, 0);
    //    ret.imageEdgeInsets = UIEdgeInsetsMake(0, -image.size.width, 0, 0);

    [ret setImage: [UIImage imageNamed: @"cancel-icon"] forState: UIControlStateNormal];
    [ret addTarget: self action: @selector(handleRedButton:) forControlEvents: UIControlEventTouchUpInside];
    //    ret.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    //    ret.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    ret.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: ret];
    redButton = ret;
}


- (void) createRelatedView {
    relatedButton = [UIButton buttonWithType: UIButtonTypeCustom];
    relatedButton.frame = self.bounds;
    relatedButton.backgroundColor = [UIColor tfPurpleColor];
    relatedButton.titleLabel.font = [UIFont gothamLight: 12];
    relatedButton.titleLabel.textColor = [UIColor whiteColor];
    relatedButton.adjustsImageWhenHighlighted = NO;
    relatedButton.translatesAutoresizingMaskIntoConstraints = NO;
    [relatedButton setImage: [UIImage imageNamed: @"node-related-image"] forState: UIControlStateNormal];
    //    [relatedButton setTitle: @"RELATED" forState: UIControlStateNormal];
    [relatedButton addTarget: self action: @selector(handleRelatedButton:) forControlEvents: UIControlEventTouchUpInside];
    relatedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0,
            10);
    relatedButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    relatedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview: relatedButton];

}

#pragma mark Utils

- (void) toggleSelection: (id) sender {
    self.selected = !self.selected;
}


#pragma mark Node state


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