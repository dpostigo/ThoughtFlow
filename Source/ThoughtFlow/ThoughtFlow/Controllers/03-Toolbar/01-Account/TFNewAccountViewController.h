//
// Created by Dani Postigo on 7/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"
#import "TFTableViewController.h"
#import "TFNewTextField.h"


@class TFNewAccountViewController;
@protocol TFNewAccountViewControllerDelegate <NSObject>
- (void) accountViewController: (TFNewAccountViewController *) accountViewController clickedSignOutButton: (UIButton *) button;
@end


@class TFTableViewController;

@interface TFNewAccountViewController : TFNewDrawerController <TFTableViewControllerDelegate,
        UITextFieldDelegate, TFNewTextFieldDelegate> {

}

@property(nonatomic) CGFloat rowHeight;
@property(nonatomic) CGFloat navigationBarHeight;
@property(nonatomic, assign) id <TFNewAccountViewControllerDelegate> delegate;

@end