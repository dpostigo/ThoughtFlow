//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFMinimizedNodeButton : UIButton {

}

@property(nonatomic, strong) NSLayoutConstraint *leftConstraint;
- (void) animateIn: (void (^)(BOOL finished)) completion;
- (void) animateOut: (void (^)(BOOL finished)) completion;
@end