//
// Created by Dani Postigo on 5/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "NodeRelatedController.h"
#import "UIView+TFFonts.h"

@implementation NodeRelatedController

- (void) viewDidLoad {
    [super viewDidLoad];

    [self.view convertFonts];
}


#pragma mark IBActions

- (IBAction) handleClose: (id) sender {

    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

@end