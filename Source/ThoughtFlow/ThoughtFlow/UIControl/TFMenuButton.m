//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMenuButton.h"

@implementation TFMenuButton

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end