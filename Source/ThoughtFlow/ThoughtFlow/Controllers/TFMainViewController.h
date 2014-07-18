//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFToolbarViewController.h"


@class TFContentView;
@class TFContentViewNavigationController;

@interface TFMainViewController : TFViewController <TFToolbarViewControllerDelegate,
        UINavigationControllerDelegate,
        TFNewAccountViewControllerDelegate, TFNewDrawerControllerDelegate> {

}

@property(weak) IBOutlet TFContentView *contentView;
@property(nonatomic, strong) TFContentViewNavigationController *contentNavigationController;

@end