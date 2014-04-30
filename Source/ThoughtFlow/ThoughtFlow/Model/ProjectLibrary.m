//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ProjectLibrary.h"

@implementation ProjectLibrary

+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (ProjectLibrary *) sharedLibrary {
    static ProjectLibrary *sharedLibrary = nil;
    if (sharedLibrary == nil) {
        //attempt to load saved file
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: @"ProjectLibrary.plist"];
//        sharedLibrary = [ProjectLibrary objectWithContentsOfFile: path];

        //if that fails, create a new, empty list
        if (sharedLibrary == nil) {
            sharedLibrary = [[ProjectLibrary alloc] init];
        }
    }
    return sharedLibrary;
}

- (id) init {
    if ((self = [super init])) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void) save {
    NSString *path = [[[self class] documentsDirectory] stringByAppendingPathComponent: @"ProjectLibrary.plist"];
    [self writeToFile: path atomically: YES];
}

@end