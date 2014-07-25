//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>
#import <DPAnimators/BasicNavigationAnimator.h>

@interface NavigationModalAnimator : BasicNavigationAnimator {

    UIRectEdge presentationEdge;
    CGSize modalPresentationSize;
}

@property(nonatomic) UIRectEdge presentationEdge;
@property(nonatomic) CGSize modalPresentationSize;
@end