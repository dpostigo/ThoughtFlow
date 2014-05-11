//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicAnimator.h"

@interface TFDrawerAnimator : BasicAnimator {

    CGSize modalSize;
    CGPoint sourcePoint;
    CGPoint destinationPoint;
}

@property(nonatomic) CGSize modalSize;
@property(nonatomic) CGPoint sourcePoint;
@property(nonatomic) CGPoint destinationPoint;
@end