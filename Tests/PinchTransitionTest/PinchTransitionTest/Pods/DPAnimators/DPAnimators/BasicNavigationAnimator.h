//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>
#import <DPAnimators/BasicAnimator.h>

typedef enum {
    NavigationAnimationTypeNone = 0,
    NavigationAnimationTypeFade = 1,
    NavigationAnimationTypeSlideUp = 2,
} NavigationAnimationType;

@interface BasicNavigationAnimator : BasicAnimator <UINavigationControllerDelegate> {

}
@end