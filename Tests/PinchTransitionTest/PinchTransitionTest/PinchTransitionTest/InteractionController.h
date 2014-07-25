//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InteractionController : UIPercentDrivenInteractiveTransition <UIViewControllerInteractiveTransitioning> {

}

@property (nonatomic, assign) BOOL interactionInProgress;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchRecognizer;
@end