//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCollectionViewCell.h"


@implementation TFCollectionViewCell {

}

- (UIImageView *) imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame: self.contentView.bounds];
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview: _imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints: @[
                [NSLayoutConstraint constraintWithItem: _imageView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: _imageView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: _imageView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: _imageView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0]
        ]];

    }
    return _imageView;
}
@end