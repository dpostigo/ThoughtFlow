//
// Created by Dani Postigo on 6/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFLayer : CALayer {

}

- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b;
- (void) setLineFromPoint: (CGPoint) a toPoint: (CGPoint) b animated: (BOOL) flag;
@end