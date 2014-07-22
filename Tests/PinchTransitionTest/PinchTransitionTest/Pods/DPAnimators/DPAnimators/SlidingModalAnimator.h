//
// Created by Dani Postigo on 5/17/14.
//

#import <Foundation/Foundation.h>
#import "BasicAnimator.h"


@interface SlidingModalAnimator : BasicAnimator {
    CGSize modalPresentationSize;
}
@property(nonatomic) CGSize modalPresentationSize;
@end