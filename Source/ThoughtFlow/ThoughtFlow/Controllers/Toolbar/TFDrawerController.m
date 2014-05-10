//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDrawerController.h"

@implementation TFDrawerController


- (IBAction) closeDrawer: (id) sender {
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

@end