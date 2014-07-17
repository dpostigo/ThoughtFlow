//
// Created by Dani Postigo on 7/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNodeLabel.h"
#import "UIFont+ThoughtFlow.h"


@implementation TFNodeLabel

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

    }

    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}


- (void) _setup {

    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont italicSerif: 14];
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
}
@end