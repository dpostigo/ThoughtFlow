//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"


@class TFNewAccountViewController;


@protocol TFNewAccountViewControllerDelegate <NSObject>

- (void) accountViewController: (TFNewAccountViewController *) accountViewController clickedSignOutButton: (UIButton *) button;

@end;

@interface TFNewAccountViewController : TFNewDrawerController {
}

@property(nonatomic, strong) UIViewController *containerController;
@property(nonatomic, assign) id <TFNewAccountViewControllerDelegate> delegate;
@end