//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFTextField;

@interface FieldTableViewCell : UITableViewCell {
    IBOutlet UITextField *textField;
    IBOutlet UIImageView *_imageView;
}

@property(nonatomic, strong) UITextField *textField;
- (TFTextField *) tfCustomTextField;
@end