//
// Created by Dani Postigo on 7/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFCharacterCountTextField : UITextField

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic) NSInteger characterLimit;
@property(nonatomic) UIEdgeInsets characterCountInsets;
@property(nonatomic) BOOL recalculatesBounds;
@property(nonatomic) CGSize characterLabelSize;

@property(nonatomic, copy) void (^updateBlock)(NSInteger);
- (NSInteger) charactersLeft;
@end