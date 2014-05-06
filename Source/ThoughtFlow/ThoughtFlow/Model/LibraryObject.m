//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "LibraryObject.h"

@implementation LibraryObject

@synthesize parent;

- (void) save {
    if (parent) {
        if ([parent respondsToSelector: @selector(save)]) {
            [parent performSelector: @selector(save)];
        }
    }
}
@end