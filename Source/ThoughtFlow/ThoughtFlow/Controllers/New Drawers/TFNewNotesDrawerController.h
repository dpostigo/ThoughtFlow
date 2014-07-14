//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"


@class Project;
@class TFDrawerNavigationController;


@interface TFNewNotesDrawerController : TFNewDrawerController <UITextViewDelegate> {
}

@property(weak) IBOutlet UILabel *textLabel;
@property(nonatomic, strong) Project *project;
@property(nonatomic, strong) UIViewController *innerController;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UITapGestureRecognizer *recognizer;

- (instancetype) initWithProject: (Project *) project;

@end