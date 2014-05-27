//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "PreloginContainerController.h"
#import "Model.h"

@implementation PreloginContainerController

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    _model.loggedIn = YES;

}


@end