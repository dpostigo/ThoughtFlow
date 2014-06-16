//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFDrawerController.h"

@interface ImageDrawerController : TFDrawerController {

}

@property(weak) IBOutlet UILabel *titleLabel;
@property(weak) IBOutlet UILabel *tagLabel;
@property(weak) IBOutlet UILabel *sourceLabel;
@property(weak) IBOutlet UITextView *descriptionLabel;
@end