//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFMenuButton.h"
#import "UIColor+TFApp.h"

@implementation TFMenuButton

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;
}

@end