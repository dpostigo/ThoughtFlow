//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFPhoto.h"

@implementation TFPhoto

@synthesize description;
@synthesize title;
@synthesize URL;


- (instancetype) initWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL {
    self = [super init];
    if (self) {
        title = aTitle;
        description = aDescription;
        URL = aURL;
    }

    return self;
}

+ (instancetype) photoWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL {
    return [[self alloc] initWithTitle: aTitle description: aDescription URL: aURL];
}


@end