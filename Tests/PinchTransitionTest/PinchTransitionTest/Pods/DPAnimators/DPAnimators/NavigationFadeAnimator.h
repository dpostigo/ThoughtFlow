//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>
#import "BasicNavigationAnimator.h"


@interface NavigationFadeAnimator : BasicNavigationAnimator <UIViewControllerAnimatedTransitioning>

@property(nonatomic) BOOL opaque;
@property(nonatomic, strong) UIView *snapshot;
@end