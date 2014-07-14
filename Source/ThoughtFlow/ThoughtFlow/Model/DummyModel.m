//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "DummyModel.h"


@implementation DummyModel

- (id) init {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void) saveResponse: (id) response forString: (NSString *) string {

    [_dictionary setObject: response forKey: string];
}
@end