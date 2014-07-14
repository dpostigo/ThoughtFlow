//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFScrollViewContentView.h"


@implementation TFScrollViewContentView

- (UIView *) hitTest: (CGPoint) point withEvent: (UIEvent *) event {

    UIView *result = nil;

    for (UIView *child in self.subviews) {
        if ([child pointInside: point withEvent: event]) {
            (result = [child hitTest: point withEvent: event]);
            if (result != nil) {
                break;
            }
        }
    }

    return result;
}


//- (id) hitTest: (CGPoint) point withEvent: (UIEvent *) event {
//    id ret = [super hitTest: point withEvent: event];
//
//    NSLog(@"%s, ret = %@", __PRETTY_FUNCTION__, ret);
//
//    if (ret == self) {
//
//        //        ret = nil;
//
//        //        return nil;
//    }
//
//    return ret;
//
//}
//
//
//- (UIView *) hitTest: (CGPoint) point withEvent: (UIEvent *) event {
//    id hitView = [super hitTest: point withEvent: event];
//    NSLog(@"%s, hitView = %@", __PRETTY_FUNCTION__, hitView);
//    if (hitView == self) {
//
//        //        return nil;
//    }
//    else {
//
//    }
//    return hitView;
//}

@end