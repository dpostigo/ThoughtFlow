//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFImageGridViewCell.h"
#import "UIView+DPKitDebug.h"


@implementation TFImageGridViewCell

- (void) prepareForReuse {
    [super prepareForReuse];

    if (_imageView) {
        //        _imageView.alpha = 0.1;
        _imageView.image = nil;
    }

    if (_topRightButton) {
        [_topRightButton removeFromSuperview];
        _topRightButton = nil;
    }
}


- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {
        _edgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        [self _setup];
    }

    return self;
}





#pragma mark - Setup

- (void) _setup {
    [self _setupImageView];
}


- (void) _setupImageView {
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

- (void) _setupOverlayView {
    _overlayView = [[UIView alloc] initWithFrame: self.contentView.bounds];
    _overlayView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"mesh-tile"]];
    [self.contentView addSubview: _overlayView];
    _overlayView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _overlayView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _overlayView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _overlayView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _overlayView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0]
    ]];
}


- (void) _setupTopLeftButton {
    _topLeftButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.contentView addSubview: _topLeftButton];
    _topLeftButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _topLeftButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _edgeInsets.top],
            [NSLayoutConstraint constraintWithItem: _topLeftButton attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: _edgeInsets.left]
    ]];
}


- (void) _setupTopRightButton {
    _topRightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.contentView addSubview: _topRightButton];
    _topRightButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: _edgeInsets.top],
            [NSLayoutConstraint constraintWithItem: _topRightButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_edgeInsets.right]
    ]];
}


- (void) _setupBottomRightButton {
    _bottomRightButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.contentView addSubview: _bottomRightButton];
    _bottomRightButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _bottomRightButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: -_edgeInsets.bottom],
            [NSLayoutConstraint constraintWithItem: _bottomRightButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self.contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: -_edgeInsets.right]
    ]];
}

#pragma mark - Private


- (UIView *) overlayView {
    if (_overlayView == nil) {
        [self _setupOverlayView];
    }
    return _overlayView;
}


- (UIButton *) topLeftButton {
    if (_topLeftButton == nil) {
        [self _setupTopLeftButton];
    }
    return _topLeftButton;
}

- (UIButton *) topRightButton {
    if (_topRightButton == nil) {
        [self _setupTopRightButton];
    }
    return _topRightButton;
}

- (UIButton *) bottomRightButton {
    if (_bottomRightButton == nil) {
        [self _setupBottomRightButton];
    }
    return _bottomRightButton;
}


- (UIImageView *) imageView {
    if (_imageView == nil) {
        [self _setupImageView];
    }
    return _imageView;
}

@end