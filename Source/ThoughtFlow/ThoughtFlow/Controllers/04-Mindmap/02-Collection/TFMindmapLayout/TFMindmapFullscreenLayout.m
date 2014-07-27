//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMindmapFullscreenLayout.h"


@implementation TFMindmapFullscreenLayout {

}

- (id) init {
    self = [super init];
    if (self) {
        //         self.numberOfRows = 1;
    }

    return self;
}


- (void) setLineAttributes: (UICollectionViewLayoutAttributes *) attributes visibleRect: (CGRect) visibleRect {
    CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
    CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;


    CGFloat zoom2 = 1 * (1 - ABS(normalizedDistance));
    NSLog(@"zoom2 = %f", zoom2);

    attributes.alpha = MAX(zoom2, 0.5);
    if (ABS(distance) < ACTIVE_DISTANCE) {
        CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(normalizedDistance));
        CGFloat alpha = 1 - ABS(normalizedDistance);
        //        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
        //        attributes.zIndex = 1;
        //        attributes.alpha = 1;
    }
    else {

        //        attributes.transform3D = CATransform3DIdentity;
        //        attributes.zIndex = 0;
        //        attributes.alpha = 0.3;
    }
}


@end