//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFRightDrawerAnimator.h"

@implementation TFRightDrawerAnimator

- (id) init {
    self = [super init];
    if (self) {
        presentationEdge = UIRectEdgeRight;
        //        viewSize = CGSizeMake(450, 0);
    }

    return self;
}


@end