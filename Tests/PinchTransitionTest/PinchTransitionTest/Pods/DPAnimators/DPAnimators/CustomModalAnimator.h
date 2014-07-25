//
// Created by Dani Postigo on 5/7/14.
//

#import <Foundation/Foundation.h>
#import "BasicModalAnimator.h"

extern CGFloat const TestAnimatorDefaultWidth;
extern CGFloat const TestAnimatorDefaultHeight;

@interface CustomModalAnimator : BasicModalAnimator <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning> {
    CGSize modalPresentationSize;
}

@property(nonatomic) CGSize modalPresentationSize;
@end