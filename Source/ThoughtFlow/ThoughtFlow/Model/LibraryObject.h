//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryObject : NSObject

@property(nonatomic, assign) id parent;
@property(nonatomic, strong) NSArray *children;
@property(nonatomic, copy) NSString *uniqueIdentifier;
- (void) save;
- (void) addChild: (id) item;
- (void) addItems: (NSArray *) items1;
- (void) removeChild: (id) item;
- (NSMutableArray *) mutableChildren;
@end