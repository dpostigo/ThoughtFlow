//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldTableViewCell : UITableViewCell {
    IBOutlet UITextField *textField;
}

@property(nonatomic, strong) UITextField *textField;
@end