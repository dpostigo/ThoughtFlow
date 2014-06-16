//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"
#import "TFDrawerPresenter.h"

@interface MindmapButtonsController : TFViewController {

    __unsafe_unretained id <TFDrawerPresenter> drawerPresenter;
    BOOL isPresenting;
}

@property(nonatomic, assign) id <TFDrawerPresenter> drawerPresenter;
@end