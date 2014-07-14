//
// Created by Dani Postigo on 7/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFBarButtonItem : UIBarButtonItem {

}

@property(nonatomic, strong) UIButton *button;
- (instancetype) initWithTitle: (NSString *) title;
- (instancetype) initWithButton: (UIButton *) button;

+ (UIButton *) closeButton;
+ (UIButton *) defaultButton;
+ (NSDictionary *) defaultAttributes;
@end