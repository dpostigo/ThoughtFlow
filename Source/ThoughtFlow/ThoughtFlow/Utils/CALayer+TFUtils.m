//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "CALayer+TFUtils.h"


@implementation CALayer (TFUtils)

- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b {

    CGFloat lineWidth = 0.5;
    CGPoint center = {0.5 * (a.x + b.x), 0.5 * (a.y + b.y)};
    CGFloat length = (CGFloat) sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = (CGFloat) atan2(a.y - b.y, a.x - b.x);

    self.position = center;
    self.bounds = (CGRect) {{0, 0}, {length + lineWidth, lineWidth}};
    self.transform = CATransform3DMakeRotation(angle, 0, 0, 1);

}


@end