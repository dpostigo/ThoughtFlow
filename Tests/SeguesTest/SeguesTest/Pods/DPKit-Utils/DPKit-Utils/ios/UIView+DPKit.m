//
//  UIView+Addons.m
//  NewsToons
//
//  Created by Daniela Postigo on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@implementation UIView (DPKit)

- (void) prettify {
    [self prettifyWithBackgroundColor: [UIColor colorWithWhite: 0.98 alpha: 1.0] borderColor: [UIColor whiteColor] shadowColor: [UIColor blackColor]];
}


- (void) prettifyWithBackgroundColor: (UIColor *) bgColor {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [bgColor getRed: &red green: &green blue: &blue alpha: &alpha];
    CGFloat offset = 0.2;
    UIColor *borderColor = [UIColor colorWithRed: (red + offset) green: (green + offset) blue: (blue + offset) alpha: alpha];

    [self prettifyWithBackgroundColor: bgColor borderColor: borderColor shadowColor: [UIColor blackColor]];
}


- (void) prettifyWithBackgroundColor: (UIColor *) bgColor borderColor: (UIColor *) borderColor {
    [self prettifyWithBackgroundColor: bgColor borderColor: borderColor shadowColor: [UIColor blackColor]];
}


- (void) prettifyWithBackgroundColor: (UIColor *) aBackgroundColor borderColor: (UIColor *) aBorderColor shadowColor: (UIColor *) aShadowColor {
    self.backgroundColor = aBackgroundColor;
    self.layer.borderColor = aBorderColor.CGColor;
    self.layer.shadowColor = aShadowColor.CGColor;
    self.clipsToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1.0;
    self.layer.masksToBounds = NO;
    self.layer.borderWidth = 1.0;
}


- (void) rasterize {
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
}


- (void) unrasterize {
    self.layer.shouldRasterize = NO;
}


- (void) setRoundedView: (UIImageView *) roundedView toDiameter: (float) newSize {
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}


/*

- (UILabel*) copyLabelFrom: (UILabel*) label {
    UILabel *newLabel = [[[UILabel alloc] initWithFrame:label.frame] autorelease];
    newLabel.backgroundColor = label.backgroundColor;
    newLabel.textColor = label.textColor;
    newLabel.textAlignment = label.textAlignment;
    newLabel.text = label.text;
    newLabel.font = label.font;
    return newLabel;

}
 
 */


- (CGFloat) left {
    return self.frame.origin.x;
}


- (void) setLeft: (CGFloat) x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat) top {
    return self.frame.origin.y;
}


- (void) setTop: (CGFloat) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat) right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void) setRight: (CGFloat) right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat) bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void) setBottom: (CGFloat) bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat) centerX {
    return self.center.x;
}


- (void) setCenterX: (CGFloat) centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat) centerY {
    return self.center.y;
}


- (void) setCenterY: (CGFloat) centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat) width {
    return self.frame.size.width;
}


- (void) setWidth: (CGFloat) width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat) height {
    return self.frame.size.height;
}


- (void) setHeight: (CGFloat) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat) ttScreenX {
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


- (CGFloat) ttScreenY {
    CGFloat y = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


- (CGFloat) screenViewX {
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;

        if ([view isKindOfClass: [UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}


- (CGFloat) screenViewY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;

        if ([view isKindOfClass: [UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


- (CGRect) screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


- (CGPoint) origin {
    return self.frame.origin;
}


- (void) setOrigin: (CGPoint) origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize) size {
    return self.frame.size;
}


- (void) setSize: (CGSize) size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void) removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
