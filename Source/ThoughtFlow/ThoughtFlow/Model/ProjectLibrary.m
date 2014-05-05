//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ProjectLibrary.h"
#import "AutoCoding.h"
#import "Project.h"
#import "NSObject+AutoDescription.h"

@implementation ProjectLibrary

+ (NSString *) documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (ProjectLibrary *) sharedLibrary {
    static ProjectLibrary *sharedLibrary = nil;
    if (sharedLibrary == nil) {
        NSString *path = [[self documentsDirectory] stringByAppendingPathComponent: @"ProjectLibrary.plist"];
        sharedLibrary = [ProjectLibrary objectWithContentsOfFile: path];

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

    for (int j = 0; j < [self.items count]; j++) {
        id item = [self.items objectAtIndex: j];
        NSLog(@"[item autoDescription] = %@", [item autoDescription]);
    }
}


- (void) addItem: (id) item {
    [self.items addObject: item];
    [self save];
}


- (void) addItems: (NSArray *) items {
    [self.items addObjectsFromArray: items];
    [items enumerateObjectsUsingBlock: ^(Project *project, NSUInteger idx, BOOL *stop) {
        project.parent = self;
    }];
    [self save];
}


@end