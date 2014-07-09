//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFNodeScrollView : UIScrollView

@property(nonatomic, strong) UIView *contentView;
- (void) recenterIfNecessary;
@end