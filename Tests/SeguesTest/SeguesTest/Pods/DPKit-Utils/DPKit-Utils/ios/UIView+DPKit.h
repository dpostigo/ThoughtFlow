//
//  UIView+Addons.h
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DPKit)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;
- (void) prettify;
- (void) prettifyWithBackgroundColor: (UIColor *) bgColor;
- (void) prettifyWithBackgroundColor: (UIColor *) bgColor borderColor: (UIColor *) borderColor;
- (void) prettifyWithBackgroundColor: (UIColor *) aBackgroundColor borderColor: (UIColor *) aBorderColor shadowColor: (UIColor *) aShadowColor;
/**
 * Removes all subviews.
 */
- (void) rasterize;
- (void) unrasterize;
- (void) setRoundedView: (UIImageView *) roundedView toDiameter: (float) newSize;


- (void) removeAllSubviews;

@end
