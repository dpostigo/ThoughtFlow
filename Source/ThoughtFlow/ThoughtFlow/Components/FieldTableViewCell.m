//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "FieldTableViewCell.h"
#import "TFCustomTextField.h"

@implementation FieldTableViewCell

@synthesize textField;

- (void) awakeFromNib {
    [super awakeFromNib];

    //    self.translatesAutoresizingMaskIntoConstraints  = NO;
}

- (UIImageView *) imageView {
    return self.tfCustomTextField.leftAccessoryImageView;
}


- (TFCustomTextField *) tfCustomTextField {
    return (TFCustomTextField *) ([self.textField isKindOfClass: [TFCustomTextField class]] ? self.textField : nil);
}

@end