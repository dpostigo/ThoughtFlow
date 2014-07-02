//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFImageGridViewCell.h"


@implementation TFImageGridViewCell

- (void) prepareForReuse {
    [super prepareForReuse];

    if (_imageView) {
        _imageView.image = nil;
    }
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

        _edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }

    return self;
}




#pragma mark - Private


- (UIButton *) topRightButton {
    if (_topRightButton == nil) {
        _topRightButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.contentView addSubview: _topRightButton];
        _topRightButton.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addConstraints: @[
                [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _edgeInsets.top],
                [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_edgeInsets.right]
        ]];
    }
    return _topRightButton;
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