//
// Created by Dani Postigo on 6/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <AutoCoding/AutoCoding.h>
#import "TFPhoto.h"
#import "PhotoLibrary.h"


@implementation TFPhoto

- (instancetype) initWithTitle: (NSString *) aTitle description: (NSString *) aDescription URL: (NSURL *) aURL tagString: (NSString *) aTagString {
    self = [super init];
    if (self) {
        _title = aTitle;
        _description = aDescription;
        _URL = aURL;
        _tagString = aTagString;
    }

    return self;
}

- (instancetype) initWithDictionary: (NSDictionary *) aDictionary {
    return [[PhotoLibrary sharedLibrary] photoFromDictionary: aDictionary];

}


- (id) init {
    self = [super init];
    if (self) {

    }

    return self;
}


- (void) setWithCoder: (NSCoder *) aDecoder {
    [super setWithCoder: aDecoder];
}



#pragma mark Safety


- (NSString *) tagString {
    if (_tagString == nil) {
        _tagString = @"";
    }
    return _tagString;

}


@end