//
// Created by Dani Postigo on 5/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLeftDrawerAnimator.h"

@implementation TFLeftDrawerAnimator

- (id) init {
    self = [super init];
    if (self) {
        modalPresentationSize = CGSizeMake(290, 0);
        presentationEdge = UIRectEdgeLeft;
        presentationOffset = CGPointMake(60, 0);
    }

    return self;
}






@end