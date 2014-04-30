//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface NewToolbarController : TFViewController {

    IBOutlet UIView *buttonsView;
    IBOutlet UIView *drawerView;
}

@property(nonatomic, strong) NSArray *buttons;
@end