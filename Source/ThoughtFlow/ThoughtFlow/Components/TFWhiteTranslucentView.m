//
// Created by Dani Postigo on 7/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFWhiteTranslucentView.h"
#import "CCARadialGradientLayer.h"


@implementation TFWhiteTranslucentView

- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}

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

#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void) _setup {
    self.backgroundColor = [UIColor clearColor];
    self.translucentTintColor = [UIColor clearColor];
    self.translucentAlpha = 0.4;
    self.translucentStyle = UIBarStyleDefault;
    self.opaque = NO;

    //    CCARadialGradientLayer *gradientLayer = [CCARadialGradientLayer layer];
    //    gradientLayer.colors = @[
    //            (id) [UIColor colorWithWhite: 1.0 alpha: 0.5].CGColor,
    //            (id) [UIColor colorWithWhite: 1.0 alpha: 0.1].CGColor,
    //    ];
    //    //    gradientLayer.locations = @[@0, @0.3, @0.5, @1];
    //    gradientLayer.locations = @[@0, @0.7];
    //    gradientLayer.gradientOrigin = self.center;
    //    gradientLayer.gradientRadius = self.width;
    //    gradientLayer.frame = self.layer.bounds;
    //    //    gradientLayer.opaque = NO;
    //    //    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    //    //    gradientLayer.opacity = 0.5;
    //    [self.layer addSublayer: gradientLayer];


    //    CGRect rect = self.bounds;
    //    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    //
    //    CGFloat width = rect.size.width;
    //    UIImage *image = [self radialGradientImage: CGSizeMake(40, 40) start: [UIColor clearColor] end: [UIColor yellowColor] centre: CGPointMake(20, 20) radius: 80];
    //
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    //    [self addSubview: imageView];
    //    //    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    //    imageView.backgroundColor = [UIColor clearColor];
    //    imageView.opaque = NO;
    //    //    [self embedView: imageView];
}

- (UIImage *) radialGradientImage: (CGSize) size start: (UIColor *) start end: (UIColor *) end centre: (CGPoint) centre radius: (float) radius {
    // Render a radial background
    // http://developer.apple.com/library/ios/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadings/dq_shadings.html

    // Initialise
    UIGraphicsBeginImageContextWithOptions(size, 0, 1);

    // Create the gradient's colours
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0, 0, 0, 0,  // Start color
            0, 0, 0, 0}; // End color
    [start getRed: &components[0] green: &components[1] blue: &components[2] alpha: &components[3]];
    [end getRed: &components[4] green: &components[5] blue: &components[6] alpha: &components[7]];

    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);

    // Normalise the 0-1 ranged inputs to the width of the image
    CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
    float myRadius = MIN(size.width, size.height) * radius;

    // Draw it!
    CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
            0, myCentrePoint, myRadius,
            kCGGradientDrawsAfterEndLocation);

    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // Clean up
    CGColorSpaceRelease(myColorspace); // Necessary?
    CGGradientRelease(myGradient); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}


@end