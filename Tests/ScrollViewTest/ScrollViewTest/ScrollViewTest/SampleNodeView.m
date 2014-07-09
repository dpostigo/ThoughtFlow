//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "SampleNodeView.h"
#import "CHTStickerView.h"


@implementation SampleNodeView

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

        UILabel *label = [[UILabel alloc] init];
        label.text = @"Left";
        label.backgroundColor = [UIColor whiteColor];
        [label sizeToFit];

        CHTStickerView *stickerView = [[CHTStickerView alloc] initWithContentView: label];
        [self addSubview: stickerView];

        //
        //        [self addSubview: label];
        //        label.translatesAutoresizingMaskIntoConstraints = NO;
        //        [self addConstraints: @[
        //                [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 10.0],
        //                [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 10.0]
        //        ]];

        UILabel *label2 = [[UILabel alloc] init];
        label2.text = @"Right";
        [self addSubview: label2];
        label2.translatesAutoresizingMaskIntoConstraints = NO;

        [self addConstraints: @[
                [NSLayoutConstraint constraintWithItem: label2 attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: label2 attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
        ]];

        UILabel *label3 = [[UILabel alloc] init];
        label3.text = @"Bottom";
        [self addSubview: label3];
        label3.translatesAutoresizingMaskIntoConstraints = NO;

        [self addConstraints: @[
                [NSLayoutConstraint constraintWithItem: label3 attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: label3 attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
        ]];
    }

    return self;
}

@end