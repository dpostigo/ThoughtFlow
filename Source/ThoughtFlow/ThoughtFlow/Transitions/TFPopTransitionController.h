//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TWTToast/TWTTransitionController.h>


@interface TFPopTransitionController : UIPercentDrivenInteractiveTransition <TWTTransitionController>


@property (nonatomic, getter = isInteractive) BOOL interactive;
@property(nonatomic, readonly) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property(nonatomic, weak) id <TWTTransitionControllerDelegate> delegate;
@end