//
// Created by Dani Postigo on 5/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryObject.h"

extern NSString *const TFNodeUpdate;


@interface TFNode : LibraryObject

@property(nonatomic) CGPoint position;
@property(nonatomic, copy) NSString *title;

- (instancetype) initWithTitle: (NSString *) aTitle;
- (instancetype) initWithTitle: (NSString *) aTitle position: (CGPoint) position;
+ (instancetype) nodeWithTitle: (NSString *) aTitle position: (CGPoint) position;

- (CGRect) rect;
- (CGPoint) center;
- (NSArray *) allChildren;
- (TFNode *) parentNode;
+ (instancetype) nodeWithTitle: (NSString *) aTitle;

@end