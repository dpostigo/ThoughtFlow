//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (DPConstraints)

- (NSLayoutConstraint *) updateSuperLeadingConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superLeadingConstraint;
- (NSLayoutConstraint *) superTrailingConstraint;
- (NSLayoutConstraint *) updateSuperTrailingConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateSuperTopConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superTopConstraint;
- (NSLayoutConstraint *) superHeightConstraint;
- (NSLayoutConstraint *) updateSuperHeightConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateHeightConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) heightConstraint;
- (NSLayoutConstraint *) updateWidthConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) widthConstraint;
@end