//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFConstants.h"

@class Model;
@class APIModel;

@interface TFViewController : UIViewController {
    Model *_model;
    NSOperationQueue *_queue;
    APIModel *_apiModel;
}

@property(nonatomic, strong) Model *model;
@property(nonatomic, strong) NSOperationQueue *queue;
- (void) postNavigationNotificationForType: (TFViewControllerType) type;
- (void) postNavigationNotificationForType: (TFViewControllerType) type pushes: (BOOL) flag;
@end