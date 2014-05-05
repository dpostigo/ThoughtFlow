//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNodeStateView.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "UIFont+ThoughtFlow.h"

@implementation TFNodeStateView

@synthesize textLabel;

@synthesize button;

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

        CGFloat padding = 15;
        textLabel = [[UILabel alloc] initWithFrame: CGRectInset(self.bounds, padding * 2, padding * 2)];
        textLabel.text = @"Placeholder";
        textLabel.font = [UIFont italicSerif: 14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = -1;
        [self addSubview: textLabel];
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [textLabel updateSuperEdgeConstraints: padding];

        textLabel.userInteractionEnabled = NO;

    }

    return self;
}


#pragma mark Getters

- (UIButton *) button {
    if (button == nil) {
        button = [UIButton buttonWithType: UIButtonTypeCustom];
        button.frame = self.bounds;
        [self addSubview: button];
        [self bringSubviewToFront: button];
    }
    return button;
}


@end