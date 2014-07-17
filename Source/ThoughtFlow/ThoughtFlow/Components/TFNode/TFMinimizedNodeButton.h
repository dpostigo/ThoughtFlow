//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNodeLabel;


@interface TFMinimizedNodeButton : UIButton

@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) NSLayoutConstraint *leftConstraint;


- (void) animateIn: (void (^)(BOOL finished)) completion;
- (void) animateOut: (void (^)(BOOL finished)) completion;
@end