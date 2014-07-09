//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"


@class Project;


@interface TFNewNotesDrawerController : TFNewDrawerController {

}

@property(weak) IBOutlet UILabel *textLabel;
@property(weak) IBOutlet UITextView *textView;
@property(nonatomic, strong) Project *project;
@end