//
// Created by Dani Postigo on 5/6/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNodeView+Utils.h"

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


@end