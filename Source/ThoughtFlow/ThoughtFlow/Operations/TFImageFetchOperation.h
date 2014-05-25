//
// Created by Dani Postigo on 5/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFOperation.h"

@interface TFImageFetchOperation : TFOperation {


    void (^imageSuccess)(NSArray *images);
}

@property(nonatomic, copy) void (^imageSuccess)(NSArray *images);
- (instancetype) initWithImageSuccess: (void (^)(NSArray *images)) anImageSuccess;
+ (instancetype) operationWithImageSuccess: (void (^)(NSArray *images)) anImageSuccess;

@end