//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFNewDrawerController.h"

@interface NotesDrawerController : TFNewDrawerController <UITextViewDelegate> {

}

@property(weak) IBOutlet UILabel *textLabel;
@property(weak) IBOutlet UITextView *textView;
@end