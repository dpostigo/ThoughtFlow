//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomBarButtonItem.h"
#import "TFKernedGothamLightLabel.h"
#import "UIView+DPKit.h"
#import "TFSpacedGothamLightButton.h"
#import "TFSpacedGothamLightLabel.h"


@implementation TFCustomBarButtonItem

- (instancetype) initWithTitle: (NSString *) aTitle image: (UIImage *) anImage {
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];


    TFKernedGothamLightLabel *label = [[TFKernedGothamLightLabel alloc] initWithFrame: view.bounds];
    label.text = aTitle;
    label.font = [UIFont fontWithName: label.font.fontName size: 12.0];
    label.textColor = [UIColor whiteColor];
    [view addSubview: label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
    ]];

    if (anImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage: anImage];
        [view addSubview: imageView];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;

        imageView.width = anImage.size.width;
        imageView.left = 0;
        label.width = label.width - anImage.size.width;
        label.left = anImage.size.width;

        [view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: imageView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: imageView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: label attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                [NSLayoutConstraint constraintWithItem: imageView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
        ]];
    } else {
        [view addConstraints: @[
                [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
                //                [NSLayoutConstraint constraintWithItem: label attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: view attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
        ]];

    }

    [view setNeedsUpdateConstraints];

    TFSpacedGothamLightButton *button = [TFSpacedGothamLightButton buttonWithType: UIButtonTypeCustom];
    button.prototype.text = aTitle;
    button.prototype.font = [UIFont fontWithName: label.font.fontName size: 12.0];
    button.prototype.textColor = [UIColor whiteColor];
    [button setTitle: aTitle forState: UIControlStateNormal];
    [button setImage: anImage forState: UIControlStateNormal];

    button.width = 320;
    button.height = 44;
    [button sizeToFit];

    self = [super initWithCustomView: button];
    if (self) {
    }

    return self;
}


@end