//
// Created by Dani Postigo on 5/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIImage+DPKit.h>
#import "UIButton+TFNodeView.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"
#import "UIView+DPConstraints.h"
#import "TFBaseNodeView.h"


@implementation UIButton (TFNodeView)

+ (UIButton *) normalNodeButton {
    UIButton *ret = [UIButton buttonWithType: UIButtonTypeCustom];
    ret.frame = CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight);
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    [ret setBackgroundImage: [UIImage imageWithColor: [UIColor deselectedNodeBackgroundColor]] forState: UIControlStateNormal];
    [ret setBackgroundImage: [UIImage imageWithColor: [UIColor whiteColor]] forState: UIControlStateSelected];
    ret.backgroundColor = [UIColor deselectedNodeBackgroundColor];
    ret.titleLabel.font = [UIFont italicSerif: 14];
    ret.titleLabel.textColor = [UIColor blackColor];
    ret.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    ret.titleLabel.textAlignment = NSTextAlignmentCenter;
    ret.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [ret setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [ret updateWidthConstraint: TFNodeViewWidth];
    [ret updateHeightConstraint: TFNodeViewHeight];
    return ret;
}


@end