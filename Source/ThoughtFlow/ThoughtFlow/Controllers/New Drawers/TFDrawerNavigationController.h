//
// Created by Dani Postigo on 7/11/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFCustomBarButtonItem;


@interface TFDrawerNavigationController : UINavigationController {

}

- (TFCustomBarButtonItem *) customLeftBarButtonItem;
- (TFCustomBarButtonItem *) customRightBarButtonItem;
@end