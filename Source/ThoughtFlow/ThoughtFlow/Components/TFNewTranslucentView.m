//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewTranslucentView.h"


@implementation TFNewTranslucentView

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


- (void) awakeFromNib {
    [super awakeFromNib];

    [self _setup];
}


- (void) _setup {

    //    self.dynamic = NO;
    //    self.tintColor = [UIColor colorWithWhite: 0.0 alpha: 1.0];

    //    //take snapshot, then move off screen once complete
    //    [self.blurView updateAsynchronously:YES completion:^{
    //        self.blurView.frame = CGRectMake(0, 568, 320, 0);
    //    }];
    //
    //
    //    self.backgroundColor = [UIColor clearColor];
    //    self.opaque = NO;
    //    self.tintColor = [UIColor colorWithWhite: 0.0 alpha: 1.0];
}
@end