//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectLibrary : NSObject

@property(nonatomic, strong) NSMutableArray *items;

+ (ProjectLibrary *) sharedLibrary;
- (void) save;

- (void) addItem: (id) item;
- (void) addItems: (NSArray *) items;
- (void) removeItem: (id) item;
@end