//
// Created by Dani Postigo on 5/7/14.
//

#import <Foundation/Foundation.h>
#import "BasicAnimator.h"

extern CGFloat const TestAnimatorDefaultWidth;
extern CGFloat const TestAnimatorDefaultHeight;

@interface CustomModalAnimator : BasicAnimator <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning> {
    CGSize modalPresentationSize;
}

@property(nonatomic) CGSize modalPresentationSize;
@end