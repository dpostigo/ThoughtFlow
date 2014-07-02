//
// Created by Dani Postigo on 6/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLayer.h"

@implementation TFLayer

- (id) init {
    self = [super init];
    if (self) {

        self.contents = nil;
        self.opaque = YES;
        self.speed = 3.0;
        self.allowsEdgeAntialiasing = YES;
    }

    return self;
}


- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b {
    [self setLineFromPoint: a toPoint: b animated: NO];
}

- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b animated: (BOOL) flag {

    CGFloat lineWidth = 0.5;
    CGPoint center = {0.5 * (a.x + b.x), 0.5 * (a.y + b.y)};
    CGFloat length = (CGFloat) sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = (CGFloat) atan2(a.y - b.y, a.x - b.x);

    self.position = center;
    self.bounds = (CGRect) {{0, 0}, {length + lineWidth, lineWidth}};
    self.transform = CATransform3DMakeRotation(angle, 0, 0, 1);

}

@end