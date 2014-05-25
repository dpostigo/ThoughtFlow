//
// Created by Dani Postigo on 5/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFImageFetchOperation.h"

@implementation TFImageFetchOperation

@synthesize imageSuccess;

- (instancetype) initWithImageSuccess: (void (^)(NSArray *images)) anImageSuccess {
    self = [super init];
    if (self) {
        imageSuccess = anImageSuccess;
    }

    return self;
}

+ (instancetype) operationWithImageSuccess: (void (^)(NSArray *images)) anImageSuccess {
    return [[self alloc] initWithImageSuccess: anImageSuccess];
}


- (void) main {
    [super main];

    [self performSuccess];
}


- (void) performSuccess {
    [super performSuccess];

    if (imageSuccess) {
        imageSuccess(@[
                [UIImage imageNamed: @"spain"],
                [UIImage imageNamed: @"running-of-the-bulls"],
                [UIImage imageNamed: @"placeholder-image"],
                [UIImage imageNamed: @"placeholder-image"],
                [UIImage imageNamed: @"placeholder-image"]
        ]);
    }
}

@end