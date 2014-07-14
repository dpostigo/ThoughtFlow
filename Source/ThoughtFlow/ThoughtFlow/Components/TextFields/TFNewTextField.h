//
// Created by Dani Postigo on 7/13/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNewTextField;


@protocol TFNewTextFieldDelegate <NSObject>

- (void) textFieldDidSave: (TFNewTextField *) textField;

@end;

@interface TFNewTextField : UITextField

@property(nonatomic) UIEdgeInsets imageInsets;
@property(nonatomic) BOOL editable;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) id <TFNewTextFieldDelegate> textFieldDelegate;


- (void) setTextColor: (UIColor *) color forState: (UIControlState) state;
- (UIColor *) colorForState: (UIControlState) state;
@end