//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewNodeView.h"
#import "TFNode.h"


@implementation TFNewNodeView

CGFloat const TFNewNodeViewWidth = 80;
CGFloat const TFNewNodeViewHeight = 80;

- (id) initWithFrame: (CGRect) frame {
    frame.size.width = TFNewNodeViewWidth;
    frame.size.height = TFNewNodeViewHeight;
    self = [super initWithFrame: frame];
    if (self) {

        [self _setup];
    }

    return self;
}

- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
    }

    return self;
}


- (void) _setup {
    self.backgroundColor = [UIColor blueColor];
}
@end