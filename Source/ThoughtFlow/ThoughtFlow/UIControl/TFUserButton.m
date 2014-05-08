//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFUserButton.h"
#import "UIImage+DPKit.h"

@implementation TFUserButton

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 2;

    [self setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
    [self setBackgroundImage: [UIImage imageWithColor: [UIColor colorWithWhite: 0.8 alpha: 0.5]] forState: UIControlStateDisabled];
}

@end