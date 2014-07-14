//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFScrollView.h"


@implementation TFScrollView
//
//- (BOOL) touchesShouldBegin: (NSSet *) touches withEvent: (UIEvent *) event inContentView: (UIView *) view {
//    NSLog(@"%s, view = %@", __PRETTY_FUNCTION__, view);
//    return [super touchesShouldBegin: touches withEvent: event inContentView: view];
//}

//
//- (UIView *) hitTest: (CGPoint) point withEvent: (UIEvent *) event {
//    id hitView = [super hitTest: point withEvent: event];
//    NSLog(@"%s, hitView = %@", __PRETTY_FUNCTION__, hitView);
//    return hitView;
//}

//
//- (id) hitTest: (CGPoint) point withEvent: (UIEvent *) event {
//    id hitView = [super hitTest: point withEvent: event];
//
//    if (hitView == self) {
//        return nil;
//    }
//    else return hitView;
//}

- (UIView *) hitTest: (CGPoint) point withEvent: (UIEvent *) event {

    NSSet *touches = [event allTouches];

    UIView *result = nil;
    for (UIView *child in self.subviews) {
        if ([child pointInside: point withEvent: event]) {
            (result = [child hitTest: point withEvent: event]);
            if (result != nil) {
                break;
            }
        }
    }
    //    NSLog(@"%s, result = %@", __PRETTY_FUNCTION__, result);

    return result;
}

//
//- (BOOL) touchesShouldBegin: (NSSet *) touches withEvent: (UIEvent *) event inContentView: (UIView *) view {
//
//    NSLog(@"content view = %@", view);
//    NSLog(@"touches = %@", touches);
//    NSLog(@"event = %@", event);
//
//    BOOL ret = [super touchesShouldBegin: touches withEvent: event inContentView: view];
////    if ([touches count] == 2) {
//    //        ret = YES;
//    //    } else {
//    //        ret = NO;
//    //        NSLog(@"[touches count] = %u", [touches count]);
//    //    }
//    return ret;
//}
//
//- (BOOL) touchesShouldCancelInContentView: (UIView *) view {
//    NSLog(@"view = %@", view);
//    return [super touchesShouldCancelInContentView: view];
//}


@end