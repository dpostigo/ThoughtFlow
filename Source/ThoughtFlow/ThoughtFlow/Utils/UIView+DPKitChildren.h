//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (DPKitChildren)

- (NSArray *) childrenOfClass: (Class) classType;
- (id) firstChildOfClass: (Class) classType;
@end