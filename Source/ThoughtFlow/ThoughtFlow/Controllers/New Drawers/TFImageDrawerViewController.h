//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"

@class TFPhoto;

@interface TFImageDrawerViewController : TFNewDrawerController

@property(nonatomic, strong) TFPhoto *image;

@property(weak) IBOutlet UILabel *titleLabel;
@property(weak) IBOutlet UILabel *tagLabel;
@property(weak) IBOutlet UILabel *sourceLabel;
@property(weak) IBOutlet UITextView *descriptionLabel;
- (instancetype) initWithImage: (TFPhoto *) image;


@end