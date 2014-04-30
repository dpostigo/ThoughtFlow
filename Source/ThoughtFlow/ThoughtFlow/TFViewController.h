//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface TFViewController : UIViewController {
    Model *_model;
    NSOperationQueue *_queue;
}

@property(nonatomic, strong) Model *model;
@property(nonatomic, strong) NSOperationQueue *queue;
@end