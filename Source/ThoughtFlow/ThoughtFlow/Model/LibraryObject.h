//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryObject : NSObject {
    NSMutableArray *items;
    __unsafe_unretained id parent;

}

@property(nonatomic, assign) id parent;
@property(nonatomic, strong) NSMutableArray *items;
- (void) save;
- (void) addItem: (id) item;
- (void) addItems: (NSArray *) items1;
- (void) removeItem: (id) item;
@end