//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLoginOperation.h"
#import "Model.h"

@implementation TFLoginOperation

- (void) main {
    [super main];

    _model.loggedIn = YES;
    [self performSuccess];
}

@end