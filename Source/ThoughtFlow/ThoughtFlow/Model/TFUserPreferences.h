//
// Created by Dani Postigo on 7/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TFUserPreferenceType) {
    TFUserPreferenceTypeImageSearch,
    TFUserPreferenceTypeAutorefresh
};

@interface TFUserPreferences : NSObject <NSCoding>

@property(nonatomic) BOOL imageSearchEnabled;
@property(nonatomic) BOOL autoRefreshEnabled;
- (void) toggleForType: (TFUserPreferenceType) type flag: (BOOL) flag;
@end