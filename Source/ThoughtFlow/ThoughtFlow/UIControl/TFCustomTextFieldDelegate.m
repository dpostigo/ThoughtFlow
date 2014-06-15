//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomTextFieldDelegate.h"
#import "TFCustomTextField.h"

@implementation TFCustomTextFieldDelegate


#pragma mark UITextFieldDelegate


- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField {
    TFCustomTextField *customTextField = (TFCustomTextField *) textField;
    if (__delegate && [__delegate respondsToSelector: @selector(textFieldShouldBeginEditing:)]) {
        return [__delegate performSelector: @selector(textFieldShouldBeginEditing:) withObject: self];
    }
    return textField.rightView == nil ? YES : customTextField.rightAccessoryButton.selected;
}


- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    if (__delegate && [__delegate respondsToSelector: @selector(textFieldShouldReturn:)]) {
        return [__delegate performSelector: @selector(textFieldShouldReturn:) withObject: self];
    }

    [textField resignFirstResponder];
    return YES;
}



//
//- (TFCustomTextField *) customTextField {
//    return
//}
@end