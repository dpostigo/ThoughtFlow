//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFNodeScrollView.h"


@implementation TFNodeScrollView

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
        [self _setup];
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}


- (void) addSubview: (UIView *) view {
    //    [super addSubview: view];
    [_contentView addSubview: view];
}


#pragma mark - Setup

- (void) _setup {
    [self _setupContentView];

    [self _setupRecognizers];
}


- (void) _setupContentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame: self.bounds];
        [super addSubview: _contentView];
        _contentView.backgroundColor = [UIColor blueColor];
    }
    _contentView.frame = self.bounds;
}

- (void) _setupRecognizers {
    for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *) gestureRecognizer;
            panGR.minimumNumberOfTouches = 2;
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];

    CGRect visibleBounds = [self convertRect: [self bounds] toView: _contentView];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);

    //    _contentView.frame = visibleBounds;

}


- (void) recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat centerOffsetX = (self.contentSize.width - self.bounds.size.width) / 2.0;
    CGFloat centerOffsetY = (self.contentSize.height - self.bounds.size.height) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);


    //    if (distanceFromCenter > 10) {

    CGPoint newOffset = CGPointMake(centerOffsetX, centerOffsetY);

    _contentView.left = newOffset.x;
    _contentView.top = newOffset.y;
    //    _contentView.width = self.width + newOffset.x;
    self.contentOffset = newOffset;

    // move content by the same amount so it appears to stay still
    for (UIView *subview in _contentView.subviews) {
        CGPoint center = [_contentView convertPoint: subview.center toView: self];
        center.x += (centerOffsetX - currentOffset.x);
        center.y += (centerOffsetY - currentOffset.y);
        subview.center = [self convertPoint: center toView: _contentView];

    }

}
@end