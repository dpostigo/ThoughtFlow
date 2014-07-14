//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFCustomBarButtonItem : UIBarButtonItem {
}

@property(nonatomic, strong) UIButton *button;
- (instancetype) initWithTitle: (NSString *) aTitle image: (UIImage *) anImage;

@end