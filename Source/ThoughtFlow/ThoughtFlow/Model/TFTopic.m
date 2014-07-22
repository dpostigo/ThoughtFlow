//
// Created by Dani Postigo on 7/21/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFTopic.h"
#import "NSString+DPKitUtils.h"


@implementation TFTopic

- (instancetype) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {

        _urlString = [dictionary objectForKey: @"FirstURL"];
        NSString *result = [dictionary objectForKey: @"Result"];
        [self getDescription: result];
        //        NSString *delimiter = @"</a>";
        //
        //        NSRange descriptionRange = [result rangeOfString: delimiter];
        //        if (descriptionRange.location != NSNotFound) {
        //            _description = [result substringFromIndex: descriptionRange.location + descriptionRange.length];
        //
        //            NSString *linkString = [result substringToIndex: descriptionRange.location];
        //
        //            NSRange startRange = [linkString rangeOfString: @">"];
        //            if (startRange.location != NSNotFound) {
        //                _title = [linkString substringFromIndex: startRange.location + startRange.length];
        //            }
        //        }

    }

    if (_title == nil || _description == nil) {
        return nil;
    }
    return self;
}


- (void) getDescription: (NSString *) result {

    NSString *ret = nil;
    NSString *delimiter = nil;
    NSString *delimiter1 = @"</a> - ";
    NSString *delimiter2 = @"</a>";

    if ([result containsString: delimiter1]) {
        delimiter = delimiter1;

    } else {
        delimiter = delimiter2;
    }

    NSRange descriptionRange = [result rangeOfString: delimiter];
    if (descriptionRange.location != NSNotFound) {
        _description = [result substringFromIndex: descriptionRange.location + descriptionRange.length];

        NSString *linkString = [result substringToIndex: descriptionRange.location];

        NSRange startRange = [linkString rangeOfString: @">"];
        if (startRange.location != NSNotFound) {
            _title = [linkString substringFromIndex: startRange.location + startRange.length];
        }
    }

    if (_title == nil || _description) {
        NSLog(@"result = %@", result);
    } else {

        NSLog(@"_title = %@", _title);
        NSLog(@"_description = %@", _description);
    }

}

@end