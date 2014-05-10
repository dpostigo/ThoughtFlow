//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIView+DPKitChildren.h"

@implementation UIView (DPKitChildren)

- (NSArray *) childrenOfClass: (Class) classType {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSArray *children = [NSArray arrayWithArray: self.subviews];

    for (int j = 0; j < [children count]; j++) {
        UIView *child = [children objectAtIndex: j];
        if ([child isKindOfClass: classType]) {
            [ret addObject: child];
        }

        if ([child.subviews count] > 0) {
            NSArray *subChildren = [child childrenOfClass: classType];
            [ret addObjectsFromArray: subChildren];
        }
    }

    return ret;
}

- (id) firstChildOfClass: (Class) classType {
    return [self childrenOfClass: classType][0];
}
@end