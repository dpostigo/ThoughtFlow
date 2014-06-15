//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicNavigationAnimator.h"

@interface TFDrawerNavAnimator : BasicNavigationAnimator {

    void (^dismissCompletionBlock)();
    CGPoint presentationOffset;
    UIRectEdge presentationEdge;
    CGSize viewSize;
    UIView *snapshot;
}

@property(nonatomic) CGPoint presentationOffset;
@property(nonatomic) CGSize viewSize;
@property(nonatomic) UIRectEdge presentationEdge;
@property(nonatomic, copy) void (^dismissCompletionBlock)();
@end