//
// Created by Dani Postigo on 7/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFLogFormatter.h"


@implementation TFLogFormatter {

}

- (NSString *) formatLogMessage: (DDLogMessage *) logMessage {

    NSMutableString *string = [[NSMutableString alloc] init];

    //    [string appendString: [NSString stringWithFormat: @"%4d ", logMessage->lineNumber]];
    [string appendString: [NSString stringWithFormat: @"%@ ", logMessage->timestamp]];
    [string appendString: [NSString stringWithFormat: @"%i ", logMessage->lineNumber]];
    [string appendString: [NSString stringWithFormat: @"[%@ ", logMessage.fileName]];
    [string appendString: [NSString stringWithFormat: @"%@] ", logMessage.methodName]];

    [string appendString: logMessage->logMsg];
    //    [string appendString: @"\r-"];
    return string;
}

@end