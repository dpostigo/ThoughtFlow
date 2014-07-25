//
// Created by Dani Postigo on 5/17/14.
//

#import <Foundation/Foundation.h>
#import "BasicModalAnimator.h"

@interface SlidingModalAnimator : BasicModalAnimator {
    CGSize modalPresentationSize;
}

@property(nonatomic) CGSize modalPresentationSize;
@end