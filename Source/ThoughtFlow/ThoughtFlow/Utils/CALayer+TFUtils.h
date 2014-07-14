//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CALayer (TFUtils)

- (void) setLineFromRect: (CGRect) rect toRect: (CGRect) toRect;
- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b;
@end