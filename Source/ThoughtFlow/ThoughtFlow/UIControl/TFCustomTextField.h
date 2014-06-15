//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const leftAccessoryWidth;
extern CGFloat const TFTextFieldBorderWidth;

@interface TFCustomTextField : UITextField <UITextFieldDelegate> {

    //    UIImageView *leftImageView;
    id <UITextFieldDelegate> __delegate;
}

- (UIButton *) rightAccessoryButton;
- (UIImageView *) leftAccessoryImageView;
@end