//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"

@interface ProjectLibrary : LibraryObject


+ (ProjectLibrary *) sharedLibrary;
- (void) save;

@end