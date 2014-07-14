//
// Created by Dani Postigo on 7/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFTableViewCell.h"


@implementation TFTableViewCell

- (void) layoutSubviews {
    [super layoutSubviews];

    [self.contentView layoutIfNeeded];
    self.detailTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.detailTextLabel.frame);
}

@end