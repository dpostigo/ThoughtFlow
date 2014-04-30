//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (DPTableView)

- (UITextField *) nextTableTextField: (UITextField *) textField;
- (NSArray *) cellTextFields;
- (void) forwardTextFieldResponder: (UITextField *) textField;
- (CGFloat) calculatedTableHeight;
@end