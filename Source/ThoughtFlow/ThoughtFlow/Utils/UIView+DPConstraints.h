//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (DPConstraints)

- (NSArray *) updateSuperConstraintsWithInsets: (UIEdgeInsets) insets;
- (NSArray *) updateSuperEdgeConstraints: (CGFloat) constant;
- (NSLayoutConstraint *) superCenterXConstraint;
- (NSLayoutConstraint *) updateSuperXConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateSuperLeadingConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superCenterYConstraint;
- (NSLayoutConstraint *) updateSuperCenterYConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superLeadingConstraint;
- (NSLayoutConstraint *) superTrailingConstraint;
- (NSLayoutConstraint *) updateSuperTrailingConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateSuperTopConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superTopConstraint;
- (NSLayoutConstraint *) superBottomConstraint;
- (NSLayoutConstraint *) updateSuperBottomConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) superHeightConstraint;
- (NSLayoutConstraint *) updateSuperHeightConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateHeightConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) heightConstraint;
- (NSLayoutConstraint *) updateWidthConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) staticWidthConstraint;
- (NSLayoutConstraint *) superWidthConstraint;
- (NSLayoutConstraint *) updateSuperWidthConstraint: (CGFloat) constant;
- (NSLayoutConstraint *) updateEqualWidthConstraint: (CGFloat) constant sibling: (UIView *) item;
- (NSLayoutConstraint *) anyWidthConstraint;
- (NSLayoutConstraint *) updateTrailingConstraint: (CGFloat) constant toSibling: (id) sibling;
- (NSLayoutConstraint *) updateTrailingConstraint: (CGFloat) constant toSibling: (id) sibling attribute: (NSLayoutAttribute) attribute;
@end