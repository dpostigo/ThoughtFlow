//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMoodboardCollectionViewCell.h"

@implementation TFMoodboardCollectionViewCell

- (void) awakeFromNib {
    [super awakeFromNib];

    _buttonsView.alpha = 0;
    _buttonsView.layer.cornerRadius = _buttonsView.height * 0.48;
    _buttonsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.5];
}


- (void) setSelected: (BOOL) selected {
    [super setSelected: selected];

    [UIView animateWithDuration: 0.5
            animations: ^{
                _buttonsView.alpha = self.selected ? 1 : 0;
            }
            completion: nil];
}

@end