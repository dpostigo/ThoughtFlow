//
//  UIView+Addons.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DPKit)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;
@property(nonatomic, readonly) CGFloat ttScreenX;
@property(nonatomic, readonly) CGFloat ttScreenY;
@property(nonatomic, readonly) CGFloat screenViewX;
@property(nonatomic, readonly) CGFloat screenViewY;
@property(nonatomic, readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;

@property(nonatomic) CGSize size;


+ (UIView *) viewWithColor: (UIColor *) color;
- (void) prettify;
- (void) prettifyWithBackgroundColor: (UIColor *) bgColor;
- (void) prettifyWithBackgroundColor: (UIColor *) bgColor borderColor: (UIColor *) borderColor;
- (void) prettifyWithBackgroundColor: (UIColor *) aBackgroundColor borderColor: (UIColor *) aBorderColor shadowColor: (UIColor *) aShadowColor;


- (void) rasterize;
- (void) unrasterize;
- (void) setRoundedView: (UIImageView *) roundedView toDiameter: (float) newSize;
- (void) removeAllSubviews;

- (void) positionAtEdge: (UIRectEdge) edge;
- (void) positionAtEdge: (UIRectEdge) edge hidden: (BOOL) flag;
@end
