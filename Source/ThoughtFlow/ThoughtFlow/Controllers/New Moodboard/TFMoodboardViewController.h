//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFContentViewNavigationController.h"


@class Project;


@interface TFMoodboardViewController : TFContentViewNavigationController {

}

@property(nonatomic, strong) Project *project;
- (instancetype) initWithProject: (Project *) project;

@end