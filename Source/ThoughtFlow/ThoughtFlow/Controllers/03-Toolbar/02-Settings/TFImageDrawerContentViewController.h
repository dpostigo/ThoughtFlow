//
// Created by Dani Postigo on 7/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFPhoto;


extern NSString *const TFImageDrawerImageCredits;
NSString *const TFImageDrawerImageDescription;
NSString *const TFImageDrawerImageTags;

@interface TFImageDrawerContentViewController : UITableViewController

@property(nonatomic, strong) TFPhoto *image;
@end