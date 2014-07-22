//
// Created by Dani Postigo on 7/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFUserPreferences.h"


@implementation TFUserPreferences

- (void) toggleForType: (TFUserPreferenceType) type flag: (BOOL) flag {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (type == TFUserPreferenceTypeImageSearch) {
        NSLog(@"flag = %d", flag);
        self.imageSearchEnabled = flag;
        NSLog(@"self.imageSearchEnabled = %d", self.imageSearchEnabled);

    } else if (type == TFUserPreferenceTypeAutorefresh) {
        self.autoRefreshEnabled = flag;

    } else {
        NSLog(@"type = %d", type);
    }
}

- (void) encodeWithCoder: (NSCoder *) coder {
    [coder encodeBool: _imageSearchEnabled forKey: @"imageSearchEnabled"];
    [coder encodeBool: _autoRefreshEnabled forKey: @"autoRefreshEnabled"];
}

- (id) initWithCoder: (NSCoder *) coder {
    self = [super init];
    if (self) {
        _imageSearchEnabled = [coder decodeBoolForKey: @"imageSearchEnabled"];
        _autoRefreshEnabled = [coder decodeBoolForKey: @"autoRefreshEnabled"];
    }

    return self;
}


- (id) init {
    self = [super init];
    if (self) {
        _imageSearchEnabled = YES;
        _autoRefreshEnabled = YES;

    }

    return self;
}


@end