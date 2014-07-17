//
// Created by Dani Postigo on 7/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNavigationBar.h"


@implementation TFNavigationBar

- (id) initWithCoder: (NSCoder *) coder {
    self = [super initWithCoder: coder];
    if (self) {

        [self _initSetup];
    }

    return self;
}

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

        [self _initSetup];
    }

    return self;
}


- (void) _initSetup {
    _customHeight = 44;
}

- (CGSize) sizeThatFits: (CGSize) size {
    //    return [super sizeThatFits: size];
    CGSize newSize = CGSizeMake(self.frame.size.width, _customHeight);
    return newSize;
}

@end