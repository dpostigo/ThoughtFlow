//
// Created by Dani Postigo on 7/3/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFTranslucentView.h"


@implementation TFTranslucentView

- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self _setup];
    }

    return self;
}


- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {
        [self _setup];
    }

    return self;
}


- (void) _setup {
    self.backgroundColor = [UIColor clearColor];
    self.translucentTintColor = [[UIColor blackColor] colorWithAlphaComponent: 0.5];
    self.translucentAlpha = 0.95;
    self.translucentStyle = UIBarStyleBlack;
    self.opaque = NO;
}
@end