//
// Created by Dani Postigo on 5/5/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface TFModalViewController : TFViewController {

    BOOL dismisses;
    UITapGestureRecognizer *dismissRecognizer;
}

@property(nonatomic, strong) UITapGestureRecognizer *dismissRecognizer;
@property(nonatomic) BOOL dismisses;
- (void) handleTapBehind: (UITapGestureRecognizer *) sender;
- (void) didTapBehind;
@end